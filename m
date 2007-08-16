Return-Path: <linux-kernel-owner+w=401wt.eu-S1759717AbXHPU5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759717AbXHPU5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 16:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756621AbXHPU4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 16:56:55 -0400
Received: from ivoti.hst.terra.com.br ([200.176.10.212]:55359 "EHLO
	ivoti.terra.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593AbXHPU4y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 16:56:54 -0400
X-Greylist: delayed 3897 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Aug 2007 16:56:54 EDT
X-Terra-Karma: 0%
X-Terra-Hash: 0843979c352a5f5634ba8f75d6d72d2f
Date: Thu, 16 Aug 2007 16:48:43 -0300
Message-Id: <JMVTP7$E1B1C27F58AFF22330472C8DFD9A4C5B@multidominios>
Subject: Re:[Spam] Re: [PATCH] UML - Add a .note.SuSE section
MIME-Version: 1.0
X-Sensitivity: 3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
From: "Alberto Pires de Oliveira Neto" <apon1@terra.com.br>
To: "jdike" <jdike@addtoit.com>
Cc: "arjan" <arjan@infradead.org>, "akpm" <akpm@osdl.org>,
       "stable" <stable@kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "user-mode-linux-devel" <user-mode-linux-devel@lists.sourceforge.net>,
       "giedrius" <giedrius@su.lt>
X-XaM3-API-Version: 4.1 (B124)
X-SenderIP: 200.192.225.10
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

  I'm really sorry, but I forget to mention, that I had the same problems on a RedHat RH4 (x86_64) too. 

> On Thu, Aug 16, 2007 at 09:30:56AM -0700, Arjan van de Ven wrote:
> > this sounds like something really stupid and bad... why would the kernel
> > need to have a per-distro note section???
> 
> On Thu, Aug 16, 2007 at 09:39:06AM -0700, Chris Wright wrote:
> > Huh!?  Why do we need a SuSE section?
> 
> On Thu, Aug 16, 2007 at 09:54:55AM -0700, Greg KH wrote:
> > I agree, what did we mess up in the SuSE kernel to require such a hack?
> 
> Beats the crap out of me.
> 
> Drop this patch - it looks like it might just be papering over
> symptoms rather than fixing the real problem - see below.
> 
> What I do know is that current UML doesn't run when built on a SuSE
> host, the UML commit which caused it to break is
> c35e584c087381aaa5f1ed40a28b978535c18fb2 
> 
> 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=c35e584c087381aaa5f1ed40a28b978535c18fb2;hp=a5bd1786fb30abe663b904f6d79bba413e9ba883
> 
> and the difference between a working UML binary and a broken one is
> this:
> 
> +  1 .note.ABI-tag 00000020  0000000060000254  0000000060000254  00000254  2**2
> +                  CONTENTS, ALLOC, LOAD, READONLY, DATA
> +  2 .note.SuSE    00000018  0000000060000274  0000000060000274  00000274  2**2
> +                  CONTENTS, ALLOC, LOAD, READONLY, DATA
> 
> and the .note.SuSE section makes the difference.
> 
> Looking into it a bit further, the contents of the section are:
> 
> 	objdump --section=.note.SuSE -s uml8796-linux-good
> 
> 	uml8796-linux-good:     file format elf64-x86-64
> 
> 	Contents of section .note.SuSE:
> 	 60000274 05000000 04000000 53755345 53755345  ........SuSESuSE
> 	 60000284 00000000 01000a02                    ........        
> 
> which seems kind of pointless, but also harmless.
> 
> The crash is in this section:
> 
>   __uml_setup_start = .;
>   .uml.setup.init : { *(.uml.setup.init) }
>   __uml_setup_end = .;
> 
> with &__uml_setup_start being 8 bytes before the start of the first
> 16-byte structure in .uml.setup.init, so the structures are misaligned
> wrt the start symbol.
> 
> I don't see any connection between the presence of a section at the
> start of the binary and this misalignment, so the patch is probably wrong.
> 
> 				Jeff
> 
> -- 
> Work email - jdike at linux dot intel dot com
> 
> E-mail classificado pelo Identificador de Spam Inteligente Terra.
> Para alterar a categoria classificada, visite
>
http://mail.terra.com.br/cgi-bin/imail.cgi?+_u=apon1&_l=1,1187292509.393134.20591.domoni.hst.terra.com.br,4040,20031127114101,20031127114101
> 
> Esta mensagem foi verificada pelo E-mail Protegido Terra.
> Scan engine: McAfee VirusScan / Atualizado em 16/08/2007 / Vers?o: 5.1.00/5099
> Proteja o seu e-mail Terra: http://mail.terra.com.br/
> 

