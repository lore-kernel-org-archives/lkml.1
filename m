Return-Path: <linux-kernel-owner+w=401wt.eu-S1755318AbYHVMSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbYHVMSr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 08:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbYHVMSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 08:18:38 -0400
Received: from web82107.mail.mud.yahoo.com ([209.191.84.220]:31119 "HELO
	web82107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753279AbYHVMSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 08:18:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=vsKWC6fHQgH6clVflm01Iz5C1iKlx0TEdff8DqbQ1xoLmfWt9k5njw7cmiljX0cFyXrmmW4DO+6EZ+SPbY3DTLu11D5ojW0/TI7kbZs996R5lCAwvZPZwNV3GutZELaTRVHw47ltMhfrFIiydhGXjaYKzVLMkZbcDhrruINxutg=;
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218
Date: Fri, 22 Aug 2008 05:18:36 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- alternate console options?
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <664503.95740.qm@web82107.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message ----

> From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
> To: David Witbrodt <dawitbro@sbcglobal.net>
> Sent: Friday, August 22, 2008 1:19:27 AM
> Subject: RE: HPET regression in 2.6.26 versus 2.6.25 -- found another user with the same regression
> 
> It may not be a help, but may I so kindly suggest setting up a serial
> console (if you have a serial port and another computer nearby, and a
> "null modem cable" by booting with kernel options
> console=ttyS0,115200n8 console=tty0

Thanks for the ideas, Jesse.  Let me address the serial console question
below, where you bring up netconsole....


> if you can't do that (and maybe even if you can) you should try booting
> with vga=1
> 
> this will boot 80x50 vga mode.

Wow, this really helps!  I didn't know this was even an option... but I 
was scratching my head, since I remember that even DOS could boot to 
80x50 text mode.

I just tried 80x50, and it works great.  I wish someone had mentioned this
sooner... but everyone probably assumes I know these things already.  Let
me repeat:

I am not a kernel developer!  I am and end user with a regression, so most
the things people here take for granted are things I don't know!


> The other option if you have a video card that supports vesafb well,
> make sure you're compiling vesafb support into your framebuffer section
> of kernel config and boot with
> vga=0x318
> appended to your kernel boot line (same line where root= is) and that
> should boot 1024x768 vga mode.

Thank you for this.  Yours is the 2nd private message I've received
regarding framebuffers, so I would like to respond publicly so that
anyone reading this thread will be aware:

I have been a UVESA framebuffer user ever since the feature was added to
the kernel.  My distro is Debian, which is only just beginning to 
provide support for UVESA FB users -- which means I had to learn to 
rebuild 'klibc' against my custom kernels and repackage the DEBs, instead
of using Debian packages.  Until recently, Debian didn't even offer the 
required 'v86d' software as packages, so I had to install that manually.
I also avoid initial ramdisks, so I pack 'v86d' with the kernel image 
itself via initramfs.

Having said that... no framebuffer of any sort is useful for me, since
my 2.6.2[67] kernels hang before framebuffers are initialized.

I appreciate all suggestions, so please don't stop sending them, but
framebuffers just cannot help me, folks!  (But "vga=1" is _extremely_
helpful!)


> There is also and early_printk boot option (I may have gotten the syntax
> wrong, but look for it in Documentation/kernel-parameters.txt)

Thanks for mentioning this, too.  It does happen to be something I knew
about before coming to LKML with my problem, but I found that provided 
little extra relevant output.


> A last and most difficult to configure option is netconsole.  If you
> compile you network driver into your kernel you can boot with
> netconsole= option and specify a remote machine that listens with
> netcat/nc to receive messages over the network.

I did find this in Documentation/* quite a while ago, but I believe that
I cannot take advantage of it for the same reason that framebuffers do
not help:  my kernels are hanging too early in the boot.  In my case,
they hang in inet_init(), which I believe would have to complete
successfully before I could use networking devices.

But... let me aim this at the experts:

Can I use the netconsole option if my kernel freezes before inet_init()
returns?  (I have been assuming "No".)

Can I use the serial console under these circumstances?  After all, I do
have 3 or 4 machines sitting right next to each other here, all with 
serial ports.  I have never had need for a null modem cable before, so I
do not have one, but I could probably obtain one with a little effort.

So far, I've been able to use printk's to get all of the info I've wanted
onto the screen just before my kernel hangs (since it always hangs at the
same point in the kernel code).


> Hope this helps, I've spent a lot of time debugging and there are a lot
> of tricks I still don't know.

Thanks for sharing the info!  The "vga=1" option will help me very much!
It also makes me feel a bit less guilty, realizing that people with much
more experience than I also still don't know all the tricks.


Much thanks,
Dave W.
