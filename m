Return-Path: <linux-kernel-owner+w=401wt.eu-S964854AbXBLKmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964854AbXBLKmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 05:42:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964855AbXBLKmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 05:42:24 -0500
Received: from web26907.mail.ukl.yahoo.com ([217.146.176.96]:41002 "HELO
	web26907.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S964854AbXBLKmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 05:42:23 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=RyswAx84qIvTTGBxhxVEK4aMUZIDk0Oco4u19lVrMYMFgJS8qhsJqp9c2caXYx82JfGaUmyE51lpDecT6+FftWCsWQvNr1VX7WPhEfcz12/tthiERNxpVNTZvtU3bHX86IYJFTEVW+F0aQ9V7AVy8f5Pf9nIRSltu90iUXOgiW4=;
X-YMail-OSG: Z.dqxq4VM1nsdx0QawjgjnJVEuqxGbkGKqeHUNNKjyeC7fpllh80aYUl9PAgB83DomvOJ9VHZqUHc_Y_hAJLPVCwzNji.fRbP70GsICEqB5gy2v5yJwi_XzfD2ZbvVw5H3N9gkqH9Hcg.tb8uO18fizt31jmFiG3d8nT.RlOnFwP3Ui6vnNMUg--
Date: Mon, 12 Feb 2007 11:42:21 +0100 (CET)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: Re : [PATCH] Compressed ia32 ELF file generation for loading by Gujin 1/3
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: vgoyal@in.ibm.com, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <m1odo0zafe.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <687898.45581.qm@web26907.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- "Eric W. Biederman" wrote:
> So I really don't care if we move whole real mode section into a note
> or if we just put a pointer to it into a note.  What is important is
> that we use a note to find it.

 Well, we can advertise by a note the section number or the section
name which contains the real-mode code, but finding the section of
type SHT_PROGBITS having SHF_EXECINSTR flags linked at zero is not
that difficult to do: it is what Gujin does right now when it does
not find the program header linked at zero.

> Which means that we could do something goofy in the linker script
> like we do with the current vdso.  So we could give it a virtual
> address of 0 and a physical address in the init code section.

 Gujin loads at the physical address, i.e. kernel is loaded at
0x100000 and not 0xC0100000, is that wrong?
 I am not sure playing these games with addresses is cleaner than
not loading a section which is not in the program header.

> For me the objective is not so much reusing the existing tools
> (although that is a plus) but more to be able to build a unified
> binary that can be used for everything, and will give us the freedom
> to do interesting things with the kernel in the future, and hopefully
> something that is more or less usable by portable bootloaders.  Having
> a different file format and different rules for different
> architectures is a pain.

 For me the objective is to have a reasonable bootloader,
I will not have the time to port back and test with every other
bootloader some transfert of code from Gujin to an ELF looking
like bzImage file.

  Etienne.


	

	
		
___________________________________________________________________________ 
Découvrez une nouvelle façon d'obtenir des réponses à toutes vos questions ! 
Profitez des connaissances, des opinions et des expériences des internautes sur Yahoo! Questions/Réponses 
http://fr.answers.yahoo.com
