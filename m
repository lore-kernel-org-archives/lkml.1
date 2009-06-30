Return-Path: <linux-kernel-owner+w=401wt.eu-S1756283AbZF3XO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283AbZF3XO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752272AbZF3XOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:14:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:33802 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915AbZF3XOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:14:19 -0400
Message-ID: <4A4A9C2F.80808@kernel.org>
Date: Tue, 30 Jun 2009 16:13:51 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Mikael Pettersson <mikpe@it.uu.se>, Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [BUG 2.6.31-rc1] HIGHMEM64G causes hang in PCI init on 32-bit
 x86
References: <200906261559.n5QFxJH8027336@pilspetsen.it.uu.se> <19013.59956.144640.331854@pilspetsen.it.uu.se> <20090629022911.GC20297@lackof.org> <4A484A8A.9020704@zytor.com> <19016.41349.636663.515540@pilspetsen.it.uu.se> <20090629112155.GJ5480@parisc-linux.org> <19016.44061.600652.676183@pilspetsen.it.uu.se> <4A490804.3040609@zytor.com> <4A494478.7020304@kernel.org> <4A494E3C.70304@kernel.org> <4A495C0D.2020807@zytor.com> <4A4966EF.6010809@kernel.org> <alpine.LFD.2.01.0906291820060.3605@localhost.localdomain> <4A496D4B.3040608@kernel.org> <19017.53428.834539.389495@pilspetsen.it.uu.se> <4A4A25B1.5010102@zytor.com> <4A4A6888.30001@kernel.org> <4A4A6B1C.7030405@zytor.com> <4A4A701F.3050700@kernel.org> <4A4A81C9.9070008@zytor.com> <4A4A88A2.7010509@kernel.org> <alpine.LFD.2.01.0906301456170.3605@localhost.localdomain> <4A4A921F.7080100@kernel.org> <alpine.LFD.2.01.0906301559390.3605@localhost.localdomain> <alpine.LFD.2.01.0906301603280.3605@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0906301603280.3605@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 30 Jun 2009, Linus Torvalds wrote:
>> I don't see any single-use trick then, and so it needs the whole statement 
>> expression mess.
> 
> Hmm. Does (((x)-1) | mask)+1) work?
> 
> I haven't thought it fully through, but that _should_ take care of the 
> "already aligned" case, no?

yes. that is right.

then how about
roundup(x,y)
round_up(x,y)

roundup doesn't need y is 2^n
but round_up does need y is 2^n, and only for x86

the name is confusing.

YH
