Return-Path: <linux-kernel-owner+w=401wt.eu-S938252AbXHIJr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938252AbXHIJr2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 05:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764365AbXHIJrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 05:47:16 -0400
Received: from web26915.mail.ukl.yahoo.com ([217.146.177.82]:32993 "HELO
	web26915.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1764363AbXHIJrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 05:47:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=kFUfpMvyegzdTfo6gsjXZmYctItYVGzEyZm6C0WoBZE8VYdFGHEDGYg/WwAtPIfxK72bVRbd6E8MziUAblIr8jdU1rWd9qrxIzz98v0Wkvt29OQtziZZVj6jWh9EAGdetHl2YBMrLvj2unh1RXY+18ES7A+oiusr4ekgtLmQF8A=;
X-YMail-OSG: 8D6Ff2oVM1lbCxJ0ezV11NCSE.IINYV5gc62jeHZXJiroAAvS2xI8S8NakGj77rFmPJJng--
Date: Thu, 9 Aug 2007 11:47:14 +0200 (CEST)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: Re: [PATCH 5/5] x86_64 EFI support -v3: EFI document
To: linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, ak@suse.de
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <183884.85434.qm@web26915.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W Biederman wrote:
> >> This is the classic skip the 16bit code and enter the kernel
> >> in 32bit mode filling in the fields that the 16bit mode code would
> >> have filled in the same way approach.
> > ......
> >
> > For in tree code it can be just updated. But weirdo-EFI-boot loader
> > cannot.
>
> So far the logic has been.
>
> Inspect bzImage.  And get boot protocol version.
> If field we need for returning data is not supported do not give
> data.  Or something like that.  Usually the fields always exist
> and you can just fill them in and we only append to the boot
> protocol structure.
>
> In practice this has been working for the last 7 years or so,
> for EFI, and LinuxBIOS, and kexec, and Gujin and I don't remember what
> else.

 Note that Gujin has a simple problem by using that 32 bits entry point:
there is no way to detect if the bzImage is compiled for 32 bits or 64 bits,
and Linux-real-mode calls a BIOS service for 64 bits only (to tell the BIOS you
are going to 64 bits - interrupt not really documented).
 Gujin can now be set to start at the 16 bits entry point, and load ELF32/ELF64
where you now the target word size, but the 32 bits entry point will "forget"
to call that service if the Linux kernel is 64 bits.
 The 32 bits entry point can still be used (-p parameter of tiny.exe) because
there seems to be a problem using the 16 bits entry point under DOS, at least
the old assembly version of the code - no more details known.

 Etienne.


      _____________________________________________________________________________ 
Ne gardez plus qu'une seule adresse mail ! Copiez vos mails vers Yahoo! Mail 
