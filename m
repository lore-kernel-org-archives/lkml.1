Return-Path: <linux-kernel-owner+w=401wt.eu-S1763535AbXGMUKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763535AbXGMUKp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 16:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758096AbXGMUKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 16:10:38 -0400
Received: from web26915.mail.ukl.yahoo.com ([217.146.177.82]:42668 "HELO
	web26915.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756765AbXGMUKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 16:10:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=CUMrUl6eAW/7u4GkTNFNBb8gOizdF2smLT61WRrl4Gcafx+WCiSFX1rpK7pzBk+y92K9zpn6oTm7ahA172Ft9VoTRz4/cHuSK40Nb5x+2yd0nWBTP5jw8atltv8Kgzd6b9AvZzMLPVDKswOHpY7L+kievWriDmjgWR6uPmmhq54=;
X-YMail-OSG: bq8n8g4VM1kv9Dsvg5ZW3jtBCrIawpBG7G3M5lTD7f9DeOoynX6xNzL5FQ.z_Z7D7w--
Date: Fri, 13 Jul 2007 22:10:35 +0200 (CEST)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: RE : Re: x86 setup code rewrite in C - revised
To: "H. Peter Anvin" <hpa@zytor.com>, Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <4697ADAC.4070009@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <700342.61011.qm@web26915.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- "H. Peter Anvin" <hpa@zytor.com> wrote:
> Chuck Ebbert wrote:

  Wrong name.

> >>  Have fun, this code:
> >>  - do not open the fast A20 gate before checking if the slow A20 gate is open or
> closed.
> 
> As does the current code; this is highly intentional behaviour since
> there are machines (in particular a whole series of machines made by
> Olivetti) which lock up if you do it differently.

 There was some discussion on this list about some machine which would not wake-up
correctly if slow A20 was not closed, long time ago. I did not really follow
the code after that discussion.
 I wonder if you should do a "outb(0xFF, 0x64);" after "outb(0xdf, 0x60);" like
the HIMEM.SYS driver, to force an immediate update of the I/O ports - I think
I also read that in this initial chip docs, long time ago also.

> >>  - Does not save and restore %ds when printing a char on the screen (%ds is
> >>  destroyed only when the content of the screen scroll - only for some video cards)
> 
> %ds?  Aren't you confusing it with the old bug which would destroy %bp?
>  If you have any references to %ds being destroyed I would be very
> surprised.  I can guarantee that very little if any assembly code I've
> ever seen that deals with INT 10h -- and I've seen a lot of it -- guards
> against %ds being randomly trashed.
> 
> However, the trashing of %bp is a well-known bug (although only for
> machines older than the ones that can run Linux) -- the Interrupt List has:
> 
> BUGS:   some implementations (including the original IBM PC) have a bug
>  	which destroys BP

 That is on Trident cards, old card but may still be used, and BIOS may have
been copied to other cards.
 Detected and documented on Gujin (boot.c and vgabios.h scroll)

> >>  and probably few other problems - just seen those by reading the patches (the
> >>  asm("") are inlined in the C code - I find it more difficult to check).
> >>
> >>  Also, I do not know if "m" is right in here:
> >> static inline u8 rdfs8(addr_t addr)
> >> {
> >> 	u8 v;
> >> 	asm("movb %%fs:%1,%0" : "=r" (v) : "m" (*(u8 *)addr));
> >> 	return v;
> >> }
> 
> The "m" is correct right there.

 strange, "g" would mean anything can go there - and this assembly instruction
should accept every access modes.
 
> >>   I may repeat me, but to find these kind of problems, it is very nice to have
> >> an ELF file to do a readelf/objdump -D -m i8086 (even after final link).
> 
> There is such a file (arch/i386/boot/setup.elf) which is retained, for
> exactly this reason.
> 
> 	-hpa
> 

  Etienne.




	
		
___________________________________________________________________________ 
Découvrez une nouvelle façon d'obtenir des réponses à toutes vos questions ! 
Profitez des connaissances, des opinions et des expériences des internautes sur Yahoo! Questions/Réponses 
http://fr.answers.yahoo.com
