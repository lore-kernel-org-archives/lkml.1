Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbYCTFIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbYCTFIx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 01:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbYCTFIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 01:08:43 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:45355 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbYCTFIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 01:08:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=S/i2nb5OhSzKy7/Y7wuG3dxwXfv6FXxIhJhoYnkJsGVoqxaWn8w49AuzoSCJ2XenV36SG1sW1YgpV/tXRc56v+DWJVuoRka5rxOpB7IA5v1BiO19GlQGzoq3QqommGlxGMiVUP3FZkPrwybsygvDfsEBzUcTq+hlzaqj/3bJuSg=
Message-ID: <5a4c581d0803192208w6db8f2aaj42eac883de126585@mail.gmail.com>
Date: Thu, 20 Mar 2008 06:08:39 +0100
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: "Rene Herman" <rene.herman@keyaccess.nl>
Subject: Re: ehci-hcd affects hda speed
Cc: "Lev A. Melnikovsky" <melnikovsky@mail.ru>,
       "David Brownell" <david-b@pacbell.net>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <47E1B062.4060709@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.00.0803050036210.31935@nev.ubzr>
	 <200803171700.26274.david-b@pacbell.net> <47DF19AD.405@keyaccess.nl>
	 <200803171855.44552.david-b@pacbell.net>
	 <alpine.LFD.1.00.0803200211230.31035@nev.ubzr>
	 <47E1B062.4060709@keyaccess.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2008 at 1:31 AM, Rene Herman <rene.herman@keyaccess.nl> wrote:
> On 20-03-08 00:47, Lev A. Melnikovsky wrote:
>
>  > Just in case - I do have an A7V8X-based PC in the office and have
>  > performed a simple experiment.
>  >
>  > #1. Idle USB controller has no effect on PCI performance (I again
>  > measured hda throughput).
>  >
>  > #2. Default value for register 4Bh is 09h.
>  >
>  > #3. I have detected no effect of changing [4Bh]=29h. Particularly, USB
>  > FLASH read speed is ~8MB/s and hda read speed is ~40MB/s regardless of
>  > [4Bh] content. During hda timing, "dd if=/dev/sda of=/dev/null bs=1024"
>  > was running in another window (/dev/sda being the USB stick).
>  >
>  > My interpretation, is that bit5 at offset 4B may _not_ be an "EHCI sleep
>  > time select" like it is for VT6212. Am I missing something?
>
>  No, very useful test, thanks much. Patch as submitted for revision 0x6x will
>  stand then.
>
>  I do wonder -- is your hda throughput also the same before _ever_ attaching
>  anything to the EHCI controller and after? In my case, the slow down only
>  happened after switching on my external USB drive once, and would persist
>  from that time until reboot (or unloading ehci-hcd, which I kept modular for
>  exactly that reason).
>
>  The sleep time wasn't the core problem, so I wonder of later VIA chips do
>  still have the active async schedule problem...
>
>  Alessandro? You said there still was a difference for you between no EHCI at
>  all and EHCI after tweaking 4B as Lev showed. How much?

When used setpci to tweak the setting, my hdparm -t went
 from 17 to 25MB/s on /dev/hda.

With your patch applied, now after booting it says 33MB/s for
 hda and 37MB/s on hdb (and I can burn DVDs at a stable 6x
 now, while growisofs backed off to 4x in less than a minute
 before the patch).

If the patch does exactly what setpci did, then perhaps I had
 other activity on hda at the moment I ran the test...

--alessandro

 "We act as though comfort and luxury were the chief requirements
 of life, when all that we need to make us really happy is
 something to be enthusiastic about."

 (Charles Kingsley)
