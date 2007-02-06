Return-Path: <linux-kernel-owner+w=401wt.eu-S1752310AbXBFUaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310AbXBFUaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 15:30:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965396AbXBFUaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 15:30:10 -0500
Received: from web26913.mail.ukl.yahoo.com ([217.146.177.80]:33794 "HELO
	web26913.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752309AbXBFUaI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 15:30:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=df5+vqMA0ThvXymUXiTyFlIFKMfzMGuzTi0yj0fiv6IzNdRnQddzM+AkFNvq72QsHEA7haBOoW3J6/Gs3OMJa9xBx8Dk9m0mNpQGh3A2muM+uq0TEfVF82EhmNahzEXN3ybNsMv+l8SmMofuYtvx0oUhEbaCwNmi7rhBh2b7hV0=;
X-YMail-OSG: IkotzB4VM1lp6U2RmiJ2k33bCXqN6EKgUOkswJaqARHeNRRZbjSX7VWWevqGqIvF_sRleWjqPqfGWJtVvlnN22HktBCn.6u4kKUnO7n92v2xY3YHWB8gMNSrax79ZdBohPypgtNH2uKPdK67N9LBKMnDQEsZ6axl1ypgoAQlaIC7OiYIgXLA6uqLBg--
X-Mailer: YahooMailRC/368.3 YahooMailWebService/0.6.132.7
Date: Tue, 6 Feb 2007 20:30:04 +0000 (GMT)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: Re : Re : Re : [PATCH] Compressed ia32 ELF file generation for loading by Gujin 1/3
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, vgoyal@in.ibm.com,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <199171.13576.qm@web26913.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Etienne Lorrain <etienne_lorrain@yahoo.fr> writes:
>>  Well, if the function called at offset 0 in the real-mode section return
>>  non zero, that is probably an error - that is Gujin interface, but do not ask
>>  me to change other bootloaders to handle that.
>>  This function is called with few parameters, one is a string pointer
>>  if the function do not want to print the problem report itself.
>>  The function is called with an offset of zero in its own intel
>>  segment.
>
> So I think there are some backwards compatibility issues with your
> real mode code interface.  Setting a new flag that says to return instead
> of printing an error message and halting would be one way to handle
> this.

 I am not sure to understand: Gujin calls a function inside the ELF real
mode program header of the Linux kernel. All the system is currently
in real mode. There isn't any limitation in this function of the kernel to
decide to print some message and not return at all, this function can
selectively do so by reading which bootloader ID it is using (another
parameter). It is not done mostly because "printf" is difficult to do
in assembler, Gujin has no problem.

> Is your real mode C code section relative such that it can be loaded
> at different addresses and still work?

  The code is relative - but not the data (first 4 Kbytes at %ds:0 and stack
 available) - but the whole lot at any segment boundary, i.e. every 16 bytes.
 Else Gujin would not work under DOS.

> The program header is for executable loaders the section header is for
> linkers and the section header is optional in PT_LOAD and PT_DYN
> executables.  Use of the section header by a loader is a bug.

  Unless if there is a problem, Gujin uses only the program header;
 it has a look in the section header just in case - that can be removed
 easily. I was wondering about a relocatable image there - but I do
 not know enough for that.

> There have been limitations but mostly with respect to page table size
> and the like but they were not limitations a bootloader had to deal with.

Was talking about this comment, but it is old:
/* 0x28000*16 = 2.5 MB, conservative estimate for the current maximum */
http://lxr.linux.no/source/arch/i386/boot/tools/build.c?v=2.4.28

> >   Well, you can generate with the proposed patch and boot with SYSLINUX,
> >  Grub and LILO, but trying to clean Linux real-mode code is where I begun.
>
> I haven't looked yet.  But I believe this is something that we can do,
> so long as cleaning and feature enhancement are not mixed in a bad way.
> Phrasing this another way.  What we can do with the interface is
> determined our interface to existing bootloaders and what bootloaders
> exist.  Basically it is the rule that we need to preserve backwards
> compatibility and changes generally need to be evolutionary ones.

  Well, if you want to preserve compatibility with other bootloaders,
 it is probably possible to put some source around the ELF kernel file,
 mostly taken from Gujin if you want (GPL), but I wonder why you would
 like to be compatible with LILO.
 Modifying the linux real mode assembler, nobody could even want to.

 Etienne.






	

	
		
___________________________________________________________________________ 
Découvrez une nouvelle façon d'obtenir des réponses à toutes vos questions ! 
Profitez des connaissances, des opinions et des expériences des internautes sur Yahoo! Questions/Réponses 
http://fr.answers.yahoo.com
