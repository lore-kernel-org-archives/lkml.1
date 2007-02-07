Return-Path: <linux-kernel-owner+w=401wt.eu-S1161349AbXBGOzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161349AbXBGOzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 09:55:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161350AbXBGOzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 09:55:42 -0500
Received: from web26907.mail.ukl.yahoo.com ([217.146.176.96]:27866 "HELO
	web26907.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161349AbXBGOzl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 09:55:41 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=sbtKxCN5hx5Y2sXhPXuEV10YvtJ0lSQ/KfM0p9Lx2hwxQBKq0840iPC+d1lCK5G7gLX0JYpnISpvPKn+tiw+YcrXpoXrdNMS4IfMrQgujsnhNbYL0rk9u9kXLYHR+6UbTm8YdEKNXwlgmsmtVxtIRcB9s5bSMoagA8c+VUOXP4s=;
X-YMail-OSG: qTSnWDsVM1lvAUcUX7Iwb9VnPeXwAh_AXODoTuKeGuzd3ZM2TXpFAAXmD8rg0mTn_bOTElECmEqGr0iX5aobeO.ZroSOyoBZAzL4rYzdY2PShdoIs.WdnbCiXQE0MOz4A_JZ17uELbQUuiAlvHqxaK4uHSoPu14kqNHKsypy67SFLpM3XQDSsw--
X-Mailer: YahooMailRC/368.7 YahooMailWebService/0.6.132.7
Date: Wed, 7 Feb 2007 14:55:39 +0000 (GMT)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: Re : Re : [PATCH] Compressed ia32 ELF file generation for loading by Gujin 1/3
To: vgoyal@in.ibm.com
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <848486.58910.qm@web26907.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
>How do I know which program header is real mode code and the boot loader
> is not supposed to load it? May be PT_LOAD header with physical addr 0?
> What happens if changes happen and down the line we start compiling 
> real mode code for non-zero address?

 Yes, any PT_LOAD below 64 Kbytes can only be real mode, and real-mode
cannot be loaded higher, and cannot be bigger than 640 Kbytes, anything
different (like with virtual address at 0xC0000000) is Linux protected mode.
Considering the linker used it is always the 4th program header, before there
were only 3 program header,third one stay the NOTE one.

> Hence I think keeping real mode code out of vmlinux might prove to be a good idea.

 Well, ELF is a format made to describe what to load, at which addres, and I assume
everyone recognise that some ELF section shall not be loaded, like the debug information.
Gujin accepts having the real-mode treated like a program text and so in the program header,
or like extra memory block with content like the symbol table used by a debugger, I do not
know what is best so have implemented the two.

> Secondly, if you compile real mode code with vmlinux, what would be the
> entry point for this ELF file? Real mode entry? Then I have not way to
> find out from ELF headers where is the protected mode entry point and
> I can not do use this vmlinux with kexec/kdump.

 I did not touch the kernel entry point, the real mode entry point is at offset zero
in the real-mode program header/section table.

> OTOH, now bzImage is relocatable. Is this image going to be relocatable?
> How do we take care of that?

 Just I did not completely understand why you need relocation (and the announce
was when I was in holidays far away). I know a simple kernel is needed to do
some debugging when the main kernel has crashed, this kernel is better loaded
at for instance 16 Mbytes. You probably do not want the same kernel as the main
one because it may crash the same way, and you start a loop - and even then
if you have exactly the same kernel it is easier to use the same write-protected
block of memory with different data sections.
 But I probably do not understand the problem so do not know what to write.

  Thanks,
 Etienne.


	

	
		
___________________________________________________________________________ 
Découvrez une nouvelle façon d'obtenir des réponses à toutes vos questions ! 
Profitez des connaissances, des opinions et des expériences des internautes sur Yahoo! Questions/Réponses 
http://fr.answers.yahoo.com
