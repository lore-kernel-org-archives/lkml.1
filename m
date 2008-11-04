Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbYKDP5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbYKDP5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 10:57:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754281AbYKDP52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 10:57:28 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:52318 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095AbYKDP51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 10:57:27 -0500
Date: Tue, 4 Nov 2008 15:57:22 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Add option to passively listen for PCIE hotplug events
Message-ID: <20081104155722.GA23314@srcf.ucam.org>
References: <bujwT-2Ew-5@gated-at.bofh.it> <buml1-6du-3@gated-at.bofh.it> <d51a1b7b-32db-41dd-a36d-911ed62f5cb4@l33g2000pri.googlegroups.com> <20081104124706.GB19401@srcf.ucam.org> <20081104133214.GA20427@srcf.ucam.org> <49105BA6.9090403@tuffmail.co.uk> <20081104143332.GA21689@srcf.ucam.org> <491063B3.4080808@tuffmail.co.uk> <20081104151128.GA22544@srcf.ucam.org> <49106DD7.9010307@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49106DD7.9010307@tuffmail.co.uk>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2008 at 03:44:23PM +0000, Alan Jenkins wrote:

> I instrumented all the delays I could find. hpc_check_lnk_status() was
> the only one that came up.  1000ms delay per call, and I get 6 such delays.

Ok, which is getting called from pciehp_enable_slot(). I'm not quite 
clear on why this is being called 6 times - any chance you can put a 
dump_stack() in there? Some are probably directly from the resume code. 
This confuses me a little, since there's a check for whether there's a 
card in the slot first. If that fails, pciehp_enable_slot() isn't 
called. If it succeeds, pciehp_enable_slot checks whether the slot is 
already powered up. If it is, it bails before doing the link setup. So 
something funny is going on here, since on the Eee I'd expect those 
slots to either be empty or already powered up.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
