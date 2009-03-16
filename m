Return-Path: <linux-kernel-owner+w=401wt.eu-S1759409AbZCPMOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409AbZCPMOk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 08:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753727AbZCPMOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 08:14:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:40902 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960AbZCPMOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 08:14:30 -0400
Date: Mon, 16 Mar 2009 09:59:09 +0100
From: Vojtech Pavlik <vojtech@suse.cz>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, clemens@ladisch.de,
       Linux Kernel ML <linux-kernel@vger.kernel.org>, robert.picco@hp.com,
       venkatesh.pallipadi@intel.com, mingo@redhat.com
Subject: Re: [Patch] Fix the possibility of insane return value of
	hpet_calibrate() against SMI.
Message-ID: <20090316085909.GK5712@suse.cz>
References: <20090313134846.24B6.E1E9C6FF@jp.fujitsu.com> <7d1d9c250903151256l36586764wfbd5e2578a45663c@mail.gmail.com> <20090316111300.7CE5.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090316111300.7CE5.E1E9C6FF@jp.fujitsu.com>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 11:34:55AM +0900, Yasunori Goto wrote:

> > I've no sense of feel for how long each calibration run would take.
> > Would doing it 5 times show up as a significant increase in the boot
> > time for those that care about boot time being as quick as possible?
> 
> Hmm. The loop times is trade off against reliable value....
> Though SMI is rare interruption, I don't know how frequent
> hypervisor's switch is.
> 
> Each calibration of this has 1 milli second.
> Do you think 5 msec is too long?
> If yes, how is 3 msec? Is it still too long?

I would suggest to instead repeat until the total cycle count stops
decreasing: That way we can avoid a SMI and yet in the best case only
run the calibration 2 times.

-- 
Vojtech Pavlik
Director SuSE Labs
