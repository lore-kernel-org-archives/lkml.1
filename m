Return-Path: <linux-kernel-owner+w=401wt.eu-S964929AbXBLN6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964929AbXBLN6I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 08:58:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964926AbXBLN6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 08:58:07 -0500
Received: from web26910.mail.ukl.yahoo.com ([217.146.176.99]:43925 "HELO
	web26910.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S964925AbXBLN6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 08:58:05 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=Message-ID:X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=37uqTfrlY+81382bSnzvomU9j6nYjQ1QnZghxHJYa6rBJfIGKvQ35Fi3tEyCJ/Fx0Rr2wUT0YhbhAvp5aSaK8L83BydxbeMB0pD9MXRwt8gep4taJ0cW+43/tOqjtsMqxQrWo2+TIvNj009B2iyltzsPLAne3KJIX/FHNy8Inx4=  ;
Message-ID: <20070212135802.27041.qmail@web26910.mail.ukl.yahoo.com>
X-YMail-OSG: a2gBtRIVM1mUvRjHYTcgqmkBPf.BfWkUWyi76DhZ9qZqAakJxZwcZwpiIHk80cMCSS9VzcElvzd5HiYyJZPYGCSSsNVH3y4Cl6evijhKBFUm5xzyTcRokdpuHPZdEOXuwfO3Riy_sziBRu84YOoj0jKf9G1xk2GM6e5w8IqFGCpjCNa4CHhtPQ--
Date: Mon, 12 Feb 2007 14:58:02 +0100 (CET)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: Re : [PATCH] Compressed ia32 ELF file generation for loading by Gujin 1/3
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: vgoyal@in.ibm.com, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <m17iuny2xg.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- "Eric W. Biederman" <ebiederm@xmission.com> wrote:
> What I was thinking is that in the not we place the physical address
> and length that we load the real mode code at.  My assumption being
> that we have marked the real mode code __init or the equivalent,
> so we always load and just ignore it later on.

 But Gujin need the real-mode part linked at zero and there isn't
anything linked at this address in the current Linux kernel, no
section at all. If you ask to do a separate link then I loose all
the symbols and the ELF standard tools are a lot less useable.

> Playing the games with the addresses does allow the existing debugging
> tools to work without problem because the end users of the code all
> examine the virtual not the physical address.

 The linker also resolve relocation in virtual addresses so this part
 needs virtual address = 0.

> I agree I want a reasonable bootloader as well.
>  [snip]
> ELF should make it much easier for people implementing simple
> stand-alone executables for testing.  As you don't even need a linker
> script or any fancy games if you don't take arguments.   Similarly
> the switch from linux to multi-boot that almost standard is just
> supporting a different argument passing format.

 There is plenty of possible future, but right now I have a simple
(OK, not perfect, but code is shown) solution which works.
I can modify bits, but there is no point complexifying the system
for possible theoretical problems - by experience you always miss
important future problem while overdesigning for some problem which
never appear.
If someone can show me a real problem - then I'd like to hear from him,
but ELF compatibility will not be up to the point where the user will
be able to run the kernel from a Xterm command line.

  Etienne.


	

	
		
___________________________________________________________________________ 
Découvrez une nouvelle façon d'obtenir des réponses à toutes vos questions ! 
Profitez des connaissances, des opinions et des expériences des internautes sur Yahoo! Questions/Réponses 
http://fr.answers.yahoo.com
