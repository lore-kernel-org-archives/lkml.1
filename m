Return-Path: <linux-kernel-owner+w=401wt.eu-S1753675AbZB1Luo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675AbZB1Luo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 06:50:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750841AbZB1Lug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 06:50:36 -0500
Received: from smtp120.mail.mud.yahoo.com ([209.191.84.77]:29066 "HELO
	smtp120.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750828AbZB1Luf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 06:50:35 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=nMtO30eT6xC80i8RPaEsRzlHufywTKwjq3G5dC2s63MC+koJvOeC+gxyUa1Cf6ZHwLCY6P6OZ92q4xveShS5z2UJ+IBTfi/wiHP4M/YYOOntkv/TBK2bxTUhdk8F0UARlOYorpkH63z23Z7zG2wgRE0slddyDtIKvbwe5BAE0GM=  ;
X-YMail-OSG: CntEMB0VM1n2djCqyCH_.DEK31GeL3VwL1uPwxcpv2v4_42Ybd.4oBsT52_f6U3G08nhStCoXhZ7xct576uRMnHqTwpGTYjO9MmwrjIL7HhXXUbgXt6EDusHsbb.ShVzYY4Ddam8sPVVz_R7byD7CuoBYxdgHBuF8QHgpsSIRW9HHezMhjnzimStZrJLwFbk0pxDG4JVOjnjaI_7jc5gDmUPKZKypzMFRzc-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] x86, mm: pass in 'total' to __copy_from_user_*nocache()
Date: Sat, 28 Feb 2009 22:49:56 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Salman Qazi <sqazi@google.com>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>
References: <20090224020304.GA4496@google.com> <200902272305.01867.nickpiggin@yahoo.com.au> <20090228082922.GB11425@elte.hu>
In-Reply-To: <20090228082922.GB11425@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902282249.57479.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 February 2009 19:29:22 Ingo Molnar wrote:
> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > On Thursday 26 February 2009 03:04:22 Linus Torvalds wrote:

> > > And we pretty much know that the only time we will ever really care
> > > about the nontemporal case is with big writes - where the "edge
> > > effects" essentially become total noise.
> >
> > I guess so. I wouldn't mind just doing cached stores all the
> > time for the reasons you say.
> >
> > But whatever. If it ever becomes *really* important, I guess
> > we can flag this kind of behaviour from userspace.
>
> Important question: is there a standing NAK for the 'total'
> parameter addition patch i did? You requested it and Linus didnt
> like it ... and i've measured it and it's just a single
> instruction in the whole kernel so it did not seem to be too bad
> to me.

Well I didn't request it so much as just being concerned about hard
transitions in behaviour in general, and also the lack of an overall
picture (which this patch improves a little, but doesn't solve --
only way to really do it is with explicit flags).


> It might be wrong on the principle though, so will revert it if
> needed, before it spreads into too many topics.

I would say if Linus didn't like it, revert it.

Do you use NFS with 1500 byte packets with a high speed network and
really fast disks (or ramdisk)? Then maybe you can measure vectored
write speedup with your patch over Salman's more basic one :)

