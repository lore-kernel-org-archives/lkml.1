Return-Path: <linux-kernel-owner+w=401wt.eu-S1161341AbXBGO3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161341AbXBGO3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 09:29:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965542AbXBGO3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 09:29:52 -0500
Received: from web26909.mail.ukl.yahoo.com ([217.146.176.98]:39544 "HELO
	web26909.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965519AbXBGO3v convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 09:29:51 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=gDu0LuwKOfjoiUc/Z68CgVm5Oq7sREniiEbmStyF2A/F54AsbMaSbjz5KebJT/Cx5ZQJBum/1GiubSSmPO0jiOaFIzbZUZLVkjOvOEoAoku6bqMFnmYl+yEii/Lr93T7erGHZb5rAC1QrE+j0w6Ug1tnpnbwmJuvlw1CVUKjI30=;
X-YMail-OSG: VhZrzjYVM1kbbIFM3TI3wqH.jl.YRFZX6htCtep2wc7jnRSVVWffH1I3WhNmsC4tDw5k7v8myEvBUhJWoKqKP.IEmZzZ6wS_IpcJ3lQ6.op1j2pzQbeOkWH3ly0Pko5gF72ILDb62YFD82sRv4Eyd7DnO9wiR7xQpjn8yljtaUh8aRxMfM50dQ--
X-Mailer: YahooMailRC/368.7 YahooMailWebService/0.6.132.7
Date: Wed, 7 Feb 2007 14:29:48 +0000 (GMT)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: Re : [PATCH] Compressed ia32 ELF file generation for loading by Gujin 1/3
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: vgoyal@in.ibm.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <923904.35193.qm@web26909.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wote:
> H. Peter Anvin wrote:
> > That's not a valid comparison, because you're using 32-bit registers to hold
> > 16-bit pointers, and then sticking 67 prefixes on completely unnecessarily.
>
> Regardless if the size is good enough we can use it :)
>
> For romcc I had a 3x code bloat over had crafted assembler, because I
> had no memory and had to inline every single function call because I
> didn't have someplace to put a return register.  So I have the
> scenario with the most code bloat.  I win!

 It is true that I try to put all my variables in big structures in Gujin, not only
because I think it is cleaner (when variables are related in their use) but also
because it reduces the problem of 32 bits addresses by using offsets to the
structure pointer, most of the time.
 In some cases, using 32 bits address prefix is better because offsets to ESP
are possible but in 16 bits you first have to copy SP to BP to reference stack
parameters. Also you can use any register as a pointer.
 Anyway, we are currently talking of 6-7 Kbytes of real-mode section for the ELF,
including root autodetection and command line generation - there is a lot of
source code to describe all those structures but no "code bloat".
 I did try to remove by "sed" some structure easily converted, like:
  mov 26(%ebx),%eax
 by:
  mov 26(%bx),%eax
for all registers esi,edi,ebx,ebp but it saved so few bytes that I did not keep it.

Eric W. Biederman wote:
> This code is currently completely Gujin specific.  If concieved as a
> replacement for setup.S it has a chance of passing review.

  If someone ever want to transfer some code from Gujin to Linux,
 without reducing too much the functionalities, I would be more than
 happy about it - I could even try to help - but considering that I
 even do not have enough time to timely answer E-mails (considering
 my paying job) and I have a lot of other parts of Gujin to improve,
 I can not lead at all on this project.

  I am not sure this task is even possible, I do not know where
 should be the limit in between bootloader and kernel - considering
 that there is also the initrd (why people didn't switch to initramfs
 already?), and being able to debug the real-mode code (like those
 DBG*.exe Gujin files), return error code, check CRC32 is a minimum.

> LILO is a lot saner then Grub, and it still supports more filesystems...
> Just because it memorizes it all before you shut down the system for
> simplicity doesn't mean lilo is worse.

  LILO is quite good, but I cannot talk too much of other bootloader
 because I simply do not use them enough (excluding ISOLINUX).
 At least LILO do not switch too early to protected mode, like Gujin.
 The thing I do not like about it is that there isn't much checks done,
 like a CRC32, so you may load the right sectors from the wrong disk.
 Also, "ioctl (file_desc, FIBMAP, &block)" seem to be less and less
 supported, either by filesystems themselves of by lower layers like
 LVM and the like. The standalone Linux executable "showmap" in Gujin
 show problems sometimes.
 
 Etienne.


	

	
		
___________________________________________________________________________ 
Découvrez une nouvelle façon d'obtenir des réponses à toutes vos questions ! 
Profitez des connaissances, des opinions et des expériences des internautes sur Yahoo! Questions/Réponses 
http://fr.answers.yahoo.com
