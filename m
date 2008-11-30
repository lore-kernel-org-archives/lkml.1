Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbYK3TCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbYK3TCz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 14:02:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbYK3TCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 14:02:47 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:64849 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752556AbYK3TCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 14:02:47 -0500
Subject: Re: [PATCH 11/15] kmemleak: Remove some of the kmemleak false
	positives
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <84144f020811290348x61cb502bn75e20c9024b889cc@mail.gmail.com>
References: <20081129103908.16726.24264.stgit@pc1117.cambridge.arm.com>
	 <20081129104408.16726.77892.stgit@pc1117.cambridge.arm.com>
	 <84144f020811290348x61cb502bn75e20c9024b889cc@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 30 Nov 2008 19:02:36 +0000
Message-Id: <1228071756.9122.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Nov 2008 19:02:37.0384 (UTC) FILETIME=[35D1DC80:01C9531E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

On Sat, 2008-11-29 at 13:48 +0200, Pekka Enberg wrote:
> On Sat, Nov 29, 2008 at 12:44 PM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > There are allocations for which the main pointer cannot be found but
> > they are not memory leaks. This patch fixes some of them. For more
> > information on false positives, see Documentation/kmemleak.txt.
[...]
> > --- a/drivers/char/vt.c
> > +++ b/drivers/char/vt.c
[...]
> > @@ -2882,6 +2883,12 @@ static int __init con_init(void)
> >         */
> >        for (currcons = 0; currcons < MIN_NR_CONSOLES; currcons++) {
> >                vc_cons[currcons].d = vc = alloc_bootmem(sizeof(struct vc_data));
> > +               /*
> > +                * Kmemleak does not track the memory allocated via
> > +                * alloc_bootmem() but this block contains pointers to
> > +                * other blocks allocated via kmalloc.
> > +                */
> > +               memleak_alloc(vc, sizeof(struct vc_data), 1);
> 
> Can we add some hooks to alloc_bootmem() to handle this? It's somewhat
> unfortunate that we need to annotate driver code.

I did a quick grep for the alloc_bootmem uses in the kernel and I don't
think these would increase the chance of getting false negatives. I'll
give it a try.

Thanks.

-- 
Catalin

