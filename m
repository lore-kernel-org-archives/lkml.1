Return-Path: <linux-kernel-owner+w=401wt.eu-S1760661AbXIODiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760661AbXIODiF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 23:38:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbXIODh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 23:37:56 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:42920 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752834AbXIODhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 23:37:55 -0400
Subject: Re: [kvm-devel] [PATCH] Refactor hypercall infrastructure
From: Zachary Amsden <zach@vmware.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Anthony Liguori <aliguori@us.ibm.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
In-Reply-To: <46EB00D8.3090903@codemonkey.ws>
References: <11897991353793-git-send-email-aliguori@us.ibm.com>
	 <46EAF4C6.8090903@goop.org>  <46EAF6FC.80207@codemonkey.ws>
	 <1189804847.5982.137.camel@bodhitayantram.eng.vmware.com>
	 <46EB00D8.3090903@codemonkey.ws>
Content-Type: text/plain
Date: Fri, 14 Sep 2007 20:37:56 -0700
Message-Id: <1189827476.5982.143.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-14 at 16:44 -0500, Anthony Liguori wrote:

> So then each module creates a hypercall page using this magic MSR and 
> the hypervisor has to keep track of it so that it can appropriately 
> change the page on migration.  The page can only contain a single 
> instruction or else it cannot be easily changed (or you have to be able 
> to prevent the guest from being migrated while in the hypercall page).
> 
> We're really talking about identical models.  Instead of an MSR, the #GP 
> is what tells the hypervisor to update the instruction.  The nice thing 
> about this is that you don't have to keep track of all the current 
> hypercall page locations in the hypervisor.

I agree, multiple hypercall pages is insane.  I was thinking more of a
single hypercall page, fixed in place by the hypervisor, not the kernel.

Then each module can read an MSR saying what VA the hypercall page is
at, and the hypervisor can simply flip one page to switch architectures.

Zach

