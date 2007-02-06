Return-Path: <linux-kernel-owner+w=401wt.eu-S1752054AbXBFNMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbXBFNMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 08:12:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbXBFNMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 08:12:07 -0500
Received: from web26908.mail.ukl.yahoo.com ([217.146.176.97]:23442 "HELO
	web26908.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752054AbXBFNMG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 08:12:06 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=jkJvi9INZBmD8FMf3EzzfwQ+OpzVyE844NBbKSFGBkKK0ouvpHVK6DUkNtsmF0Kl8o+zSlCs7Xhl1OxhM4K9fiCDM1pOJTzYp9ghhvcjmqDEasnabPNDXrV3QrXtwPjeuCryYOoW+ceHM+wemZLySMNE+DqtvG0acGMfgPAdV2s=  ;
Message-ID: <20070206131205.17780.qmail@web26908.mail.ukl.yahoo.com>
X-YMail-OSG: 1n5ZK2MVM1mzgZmGvXY2MmcAKQ6xFR6op.RXeEptwAivb33PnfXtEgtxPhTafQ0QWxHwCB730dQtGNwm5igTNLUHh7wYGf8Kou2cP8yunDxxG13nYuv2KoCj3R4NMbYJ5hfdko.Rx4U6UCWzmyxrFO0j3pZtaUaXDyfiv9oJ1CDqvg4eO6E8fg--
X-Mailer: YahooMailRC/368.3 YahooMailWebService/0.6.132.7
Date: Tue, 6 Feb 2007 13:12:05 +0000 (GMT)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: Re : [PATCH] Compressed ia32 ELF file generation for loading by Gujin 1/3
To: vgoyal@in.ibm.com, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Building real mode code with kernel binary (vmlinux) has got another
> disadvantage that it breaks using vmlinux for kdump purposes. One compiles
> the kernel binary to execute from a different address but real mode code/data
> will continue to be at virtual/physical addr 0 and kexec can not load it
> as that physical memory is not available at all. Kdump skips the real mode
> code execution.

 But that is exactly what you want and need for kdump, isn't it?
 The ELF file did not change, the program header has the last index at
address 0 that you do not want to load because you do not want to
execute the real-mode code. Load the rest and provide the 4 Kbytes
parameter page - it should work.

> I don't know much about Gujin, but advantage here seems to be that it has
> capability to load elf files and that's why the attempt to turn kernel binary
> into a compressed elf image. Why don't we then simply add an ELF header to
> bzImage and Gujin and any ELF loader including Gujin, should be able to load
> it? (As Eric had done in one of the implementations in the past?) Why to 
>create the new infrastructure?

 Because I think when a program evolves it has to get simpler to generate,
run and maintain/debug - while doing more stuff. The number of assembler
lines has to reduce because they are difficult to maintain.
 Removing a ELF header to modify the binary and stick another ELF header
is not exactly what I think simpler - a bit like linking at a fix address and
then modifying the whole set.

HPA wrote:
> Well, Gujin wants additional code too.
> Putting an ELF header on bzImage broke some bootloaders (GRUB, I believe),
> so that's not going to happen again. See the relocatable bzImage thread...

  I also refuses to load a big file at a fixed address before asking the BIOS
 for information, I only crash once the memory when I am pretty sure everything
 seems alright, interruption disabled, just before jumping to the kernel
 entry point. Cannot do that with bzImage. Cannot easily debug without
 this feature.

> Thanks
> Vivek

  Thanks for you comment.
 Etienne.


	

	
		
___________________________________________________________________________ 
Découvrez une nouvelle façon d'obtenir des réponses à toutes vos questions ! 
Profitez des connaissances, des opinions et des expériences des internautes sur Yahoo! Questions/Réponses 
http://fr.answers.yahoo.com
