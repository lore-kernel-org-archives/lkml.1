Return-Path: <linux-kernel-owner+w=401wt.eu-S939327AbXGSRVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939327AbXGSRVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938367AbXGSRU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:20:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:56716 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S940490AbXGSRU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:20:56 -0400
Date: Thu, 19 Jul 2007 19:20:10 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Arjan van de Ven <arjan@infradead.org>
cc: Bodo Eggert <7eggert@gmx.de>, Rene Herman <rene.herman@gmail.com>,
       Ray Lee <ray-lk@madrabbit.org>, Matt Mackall <mpm@selenic.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
In-Reply-To: <1184714999.2691.0.camel@laptopd505.fenrus.org>
Message-ID: <Pine.LNX.4.58.0707191907160.3442@be1.lrz>
References: <8FO1e-2jW-35@gated-at.bofh.it> <8Ghmx-60z-17@gated-at.bofh.it>
  <8Gj55-hJ-5@gated-at.bofh.it> <8GkNo-2Vb-1@gated-at.bofh.it> 
 <8GtnN-7TG-23@gated-at.bofh.it> <8GVjY-PL-25@gated-at.bofh.it> 
 <E1IA7j1-0000j9-I3@be1.lrz> <469A5D7C.5010904@gmail.com> 
 <Pine.LNX.4.58.0707161523500.25779@be1.lrz>  <469BF104.1040703@gmail.com> 
 <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com> 
 <469BF768.6040200@gmail.com> <Pine.LNX.4.58.0707170143200.29868@be1.lrz> 
 <469C0D32.2090102@gmail.com> <Pine.LNX.4.58.0707171119050.2210@be1.lrz> 
 <469CD456.801@gmail.com>  <Pine.LNX.4.58.0707172334210.2141@be1.lrz>
 <1184714999.2691.0.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19O3PEkKM5KK3Bbg8ZvVSE0IISS3x91QFajqZj
 KGows18CjMf64biYVJass5ObisqvLmKv6zhl+kqI1DRyWVCuLL
 eAbriqOnjlVafnFAKXDeg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007, Arjan van de Ven wrote:

> > 1) It all can be reduced to 4K + 4K by asuming all IRQ happen on one CPU.
> 
> no it's separate stacks for soft and hard irqs, so it's really 4+4+4

Thanks, I missed that information. Unfortunately this change still does 
not help if one of these stacks needs to grow beyond 4K.

> another angle is that while correctness rules, userspace correctness
> rules as well. If you can't fork enough threads for what you need the
> machine for, why have the machine in the first place?

Userspace can't work correctly after the kernel crashed, but it can fail 
gracefully if it can't create enough threads.

I'd really like to be able to select 4K stacks, but as long as that stack
would overflow, I can't, and it can't be default, too.
-- 
Top 100 things you don't want the sysadmin to say:
8. ...and after I patched the microcode...
