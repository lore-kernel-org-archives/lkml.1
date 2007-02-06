Return-Path: <linux-kernel-owner+w=401wt.eu-S1751795AbXBFMtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbXBFMtq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 07:49:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbXBFMtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 07:49:46 -0500
Received: from web26911.mail.ukl.yahoo.com ([217.146.177.78]:27570 "HELO
	web26911.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751795AbXBFMtp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 07:49:45 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=0zzn7b2a64RcRqfetlHzWky1Nfr030362AkAi6405+x0wZEIyPaHpSF2lMIzgek7mlOeY4BWwIQE4l5afUbw10kv8M7qRiP0ZIqKmv04wOLUdMjiJTV8SJ/BqJfJNrvpTnWD6fTHnlch7aieipnKLsxg1Bg2ESi08sfhGMcpWFs=;
X-YMail-OSG: tjZTR5kVM1lJT4tgbJS4u5tz9YAEQKLPw86dKz.BLj_YLNql8o2mbgEdMZTRZPvL4y5iEa6OlIn0Q3p8reZJBJEMhd5UzRLGx0rgl8YHicFhzkt0xHmOCGiIJ8gDbPcijphydruucZ6mvhYre8IDc.j89QEXGSAra5e2G5wM_FN7Zxd9zYoYGwW.og--
X-Mailer: YahooMailRC/368.3 YahooMailWebService/0.6.132.7
Date: Tue, 6 Feb 2007 12:49:42 +0000 (GMT)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: Re : [PATCH] Compressed ia32 ELF file generation for loading by Gujin 1/3
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <962959.49182.qm@web26911.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> First of all, if sending attached patches, *MAKE SURE* they're text/plain.

  Sorry, next time I'll do.

> The standard way to do this is to have a command line argument named 
> BOOT_IMAGE (as in BOOT_IMAGE=/foo/bar/baz).  There is no reason to do 
> this differently from every other bootloader.

  I was more thinking as a command line like the shell command line,
  I can probably modify that. It is only to guess the root filesystem,
  I do not know if BOOT_IMAGE= usually contains the fully qualified path.
  Gujin just adds this string from the "name" field of the GZIP file,
  so it can be manually adjusted.

> Why build the real-mode code as part of the kernel binary?  If you have 
> to reference kernel symbols, you can do that with the -R option to ld. 
> Bundling it into the kernel binary just to then extract it later is 
> silly at best.

  Gujin do not reference any kernel symbol; the complete file is loaded
  at once at a variable memory address. Then Gujin moves the real-mode
  section at a valid address and execute it, then it moves the code and data
  protected mode at a valid address and execute it.
  In this mode Gujin just act as an ELF program loader.
  The variable memory address is good when you are running DOS/HIMEM
  for instance to debug hardware/BIOS - it does not crash random address
  before requesting BIOS services like all other bootloaders.

>> +       @echo  "  /boot/linux-$(KERNELRELEASE).kgz - create a boot kernel for the Gujin bootloader"
> This doesn't exactly fit very well the standard pattern.  Something like 
>  make gujin TARGET=... would be more like it.

  For me, the make parameter is the file you want to get - up to "make" 
  to sort out how to generate it.

> Given how many of your files are highly Gujin-specific, and have generic 
> names, please put them in a subdirectory (e.g. arch/i386/boot/gujin/).

  I do agree that there is a functionality I am not sure of the interface, that
  is the automatic root detection. Nearly everybody put the kernel in its
  own distribution filesystem (Fedora kernel in Fedora root filesystem, Debian
  kernel in Debian root filesystem...) or only has a single distribution.
  The bootloader is loading this kernel file - so it knows exactly which
  disk/partition to propose as root to the kernel.
  So under the compilation switch "ROOT_EXTENSIVE_SEARCH", there
  is the exposed Gujin interface to help the real-mode function of the
  ELF file decide what to do.

  I do disagree that the BIOS interface like "union drive_info" of realmode.h
  is Gujin stuff, it is just that I a lot prefer a C interface with a clean
  structure than "#define OFFSET_OF_THIS_BYTE, #define MASK_OF_THIS_BIT"
  everywhere, I prefer programing in C than programing in CPP.
  Ok, most of the fields are not used - even by Gujin - it is just how the BIOS
  documentation describes them.

>    -hpa

  Thanks for your comments. Sorry I could not answer immediately but
  I had to sleep a bit. I try to reply to the other messages together.
  Etienne.


	

	
		
___________________________________________________________________________ 
Découvrez une nouvelle façon d'obtenir des réponses à toutes vos questions ! 
Profitez des connaissances, des opinions et des expériences des internautes sur Yahoo! Questions/Réponses 
http://fr.answers.yahoo.com
