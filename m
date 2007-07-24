Return-Path: <linux-kernel-owner+w=401wt.eu-S935458AbXGXJAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935458AbXGXJAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 05:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759020AbXGXJAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 05:00:38 -0400
Received: from gw.goop.org ([64.81.55.164]:52160 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762660AbXGXJAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 05:00:37 -0400
Message-ID: <46A5BF81.9040303@goop.org>
Date: Tue, 24 Jul 2007 01:59:45 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: LKML <linux-kernel@vger.kernel.org>, andi@firstfloor.org,
       nix.or.die@googlemail.com
Subject: Re: 2.6.22-git17 boot failure
References: <46A3EC92.3050504@imap.cc> <46A3FBB7.9000608@imap.cc> <46A46BF9.6010906@goop.org> <46A481FD.2030607@imap.cc> <46A4C081.6070305@goop.org> <46A504A3.3070205@imap.cc> <46A51079.5030006@goop.org> <46A53396.2060902@imap.cc> <46A5444D.4080304@goop.org> <46A5BD97.10601@imap.cc>
In-Reply-To: <46A5BD97.10601@imap.cc>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Schmidt wrote:
> Jeremy Fitzhardinge schrieb:
>   
>> Well, it looks to me like it all falls over once it hits usermode;
>> everything up till then is identical (except for the Xen-related
>> initcalls which naturally don't exist in the non-Xen case).
>>     
>
> Just a wild thought: could the actual problem be with accessing the
> initrd? After all, everything that's failing is based on modules
> which are stuffed there. But I know far too less about initrd to
> pursue this thought further.
>   

Well, the kernel is managing to mount the initrd as a filesystem, and
the "waiting for root to appear" message looks like its coming from
usermode as well.  So I suspect its something to do with module loading,
but I can't imagine what at the moment.

Statically compiling the scsi/ahci/etc drivers will help make some
progress in debugging this.

I really can't see how its directly Xen related.  It looks like either:

   1. some bug which only appears with particular kernel memory layouts,
      and enabling Xen happens to make it bad
   2. or some kind of linker bug, possibly triggered by Xen's ELF notes
      (but I'd really expect this to break in a more basic way)
   3. ...?


>> I'm at a loss.  I don't know if there's some way to debug the initrd in
>> more detail.  I suspect that its failing all PCI probing, rather being a
>> specific SCSI/AHCI problem (since none of the other messages appear either).
>>
>> Does the Xen case just hang, or reboot, or what?  The kernel messages
>> just appear to stop.  I'd expect it to at least complain about not
>> mounting the root filesystem or something.
>>     
>
> Yes, of course. Sorry, I thought I'd mentioned that. It shows the
> standard behaviour of a Suse that cannot mount its root filesystem:
> first a message: "waiting for /dev/system/root to appear" followed
> by a series of dots, and then fallback into a standalone /bin/sh.
>   

Oh, you get a shell?  What does /proc/pci have in it?  What happens if
you manually try to modprobe something?  That gives us much more to work
with.

    J
