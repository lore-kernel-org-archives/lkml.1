Return-Path: <linux-kernel-owner+w=401wt.eu-S1761675AbYJJVN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761675AbYJJVN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 17:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759233AbYJJVNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 17:13:21 -0400
Received: from vms172071pub.verizon.net ([206.46.172.71]:38460 "EHLO
	vms172071pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757993AbYJJVNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 17:13:21 -0400
X-Greylist: delayed 1967 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Oct 2008 17:13:21 EDT
Date: Fri, 10 Oct 2008 16:40:25 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: [RFC][PATCH 2/2] first callers of process_deny_checkpoint()
In-reply-to: <20081010195339.GA509@elte.hu>
X-X-Sender: lenb@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Dave Hansen <dave@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       containers@lists.linux-foundation.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Message-id: <alpine.LFD.1.10.0810101637050.7059@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20081009190405.13A253CB@kernel> <200810101517.17809.rjw@sisk.pl>
 <20081010145422.GE11695@elte.hu> <200810102153.45174.rjw@sisk.pl>
 <20081010195339.GA509@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 10 Oct 2008, Ingo Molnar wrote:

> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > > > Surely not ACPI-compliant.
> > > 
> > > what do you mean?
> > 
> > The ACPI spec says quite specifically what should be done while 
> > entering hibernation and during resume from hibernation.  We're not 
> > following that in the current code, but we can (gradually) update the 
> > code to become ACPI-compilant in that respect.  However, if we go the 
> > checkpointing route, I don't think that will be possible any more.
> 
> ah, i see. I did not mean to utilize any ACPI paths but simple powerdown 
> or reboot.

If we don't enter ACPI S4, and instead poweroff,
then we'll lose the capability to wake the system from
devices that are capable of waking S4, but incapable of waking S5.

ie. The power button will still work, but others may not.

cheers,
-Len

> If we checkpoint all apps to persistent disk areas (which the checkpoint 
> patches in this thread are about), then we can just reboot the kernel 
> and forget all its state.
> 
> That capability can be used to build a really robust hibernation 
> implementation IMO: we could "hibernate/kexec" over between different 
> kernel versions transparently. (only a small delay will be noticed by 
> the user - if we do it smartly with in-kernel modesetting then not even 
> the screen contents will be changed over this.)

