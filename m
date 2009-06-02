Return-Path: <linux-kernel-owner+w=401wt.eu-S1758840AbZFBSGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840AbZFBSGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 14:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757405AbZFBSGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 14:06:41 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:43133 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757182AbZFBSGl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 14:06:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=B+Lb/5TXzHn4On6wR7VyzmbE86tBqtHMDoGCm34TaXkqWpeuHzmOywMUMKQbxjMztX
         JTm5CPZJoLKh81SnuYew8PWZQYnGekslam9Q9ahfNPaCGXS+l6qrUvIAdMyn5sRfCDGs
         XB9b6dVwGHOIz53u7hohNO5L36BR/9eIkqSP8=
MIME-Version: 1.0
In-Reply-To: <20090602150339.GF3914@think>
References: <4A0B62F7.5030802@goop.org> <20090525091527.GA7535@elte.hu>
	 <4A1C3805.7060404@goop.org> <20090528061702.GB6920@wotan.suse.de>
	 <20090530102330.GC16913@elte.hu> <20090602141802.GC3914@think>
	 <a36005b50906020749p22b89693k5c4ae171d18966a7@mail.gmail.com>
	 <20090602150339.GF3914@think>
Date: Tue, 2 Jun 2009 21:06:41 +0300
X-Google-Sender-Auth: 668cba711bed3d98
Message-ID: <84144f020906021106l7927e005o6bcd555b8f51b03b@mail.gmail.com>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native 
	kernels
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Chris Mason <chris.mason@oracle.com>, Ulrich Drepper <drepper@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

On Tue, Jun 2, 2009 at 6:03 PM, Chris Mason <chris.mason@oracle.com> wrote:
>> I find it ridiculous to use the "but it's used" argument to try to
>> force the code into the kernel.  By this argument you can say the same
>> about crap like ndiswrapper and similarly harmful code.
>
> I'm not saying to take harmful code, I'm saying to take code with a
> small performance regression under a specific CONFIG_.  Slub regresses
> more than 1% on database loads, CONFIG_SCHED_GROUPS, the list goes on
> and on.

Maybe it's just me but you make it sound like the SLUB regression is
okay. It's not.

Unfortunately we're now in a position where we can't just remove SLUB
(it's an improvement over SLAB for NUMA) so we're stuck with two
allocators with third one on its way to the kernel. So yes, it makes a
lot of sense to me to fix CONFIG_PARAVIRT regression before merging
more of the xen stuff in the kernel. It's always easier to fix these
things before they hit the kernel and people start to depend on them.

                        Pekka
