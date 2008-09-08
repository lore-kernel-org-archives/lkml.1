Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbYIHOaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbYIHOaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 10:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbYIHOaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 10:30:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32855 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbYIHOaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 10:30:22 -0400
Date: Mon, 8 Sep 2008 16:30:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Luca Tettamanti <kronos.it@gmail.com>, "H. Peter Anvin" <hpa@kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@redhat.com
Subject: Re: [2.6.27] overlapping early reservations [was: early exception
	- lockdep related?]
Message-ID: <20080908143003.GB10580@elte.hu>
References: <b8P0N-3Dp-11@gated-at.bofh.it> <b8PaB-3Or-23@gated-at.bofh.it> <b8Q6x-51x-11@gated-at.bofh.it> <b961C-rW-9@gated-at.bofh.it> <b97qL-26L-15@gated-at.bofh.it> <E1KcNQE-0001Le-8P@be1.7eggert.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KcNQE-0001Le-8P@be1.7eggert.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bodo Eggert <7eggert@gmx.de> wrote:

> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > In any case it would make sense to turn that particular overlap 
> > situation into a warning message and disable initrd decompress - and 
> > try to boot with whatever is built-in the kernel.
> 
> If I explicitely tell my system to load a ramdisk, ignoring it is a 
> bug.

we dont really ignore it - we detect that it got corrupted by the 
bootloader. (it got overwritten by the kernel image - information has 
been destroyed irrevocably)

how we react to that breakage we detect is up to debate: it's fine to 
try to continue (presumably a huge vmlinux means it has all the drivers 
already) - and if a system relies on an initrd it wont get fast in 
bootup anyway.

that's why i suggested to print a warning, do a 5 seconds delay after 
that warning via mdelay(5000) so that the user has a chance to notice 
what is wrong, and then try to continue. Panicking is just as fine.

	Ingo
