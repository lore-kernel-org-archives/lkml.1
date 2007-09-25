Return-Path: <linux-kernel-owner+w=401wt.eu-S1758235AbXIYCfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbXIYCfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 22:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbXIYCe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 22:34:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268AbXIYCe6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 22:34:58 -0400
Date: Mon, 24 Sep 2007 22:34:44 -0400
From: Rik van Riel <riel@redhat.com>
To: Jan =?UTF-8?B?S3VuZHLDoXQ=?= <jkt@gentoo.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kswapd high CPU usage with no swap
Message-ID: <20070924223444.62f0622d@bree.surriel.com>
In-Reply-To: <46F852B6.7030207@gentoo.org>
References: <46F852B6.7030207@gentoo.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2007 02:13:42 +0200
Jan Kundrát <jkt@gentoo.org> wrote:

> Hi folks,
> I use a 2.6.22-gentoo-r2 SMP kernel with fglrx 8.40.4 [1],
> tp_smapi-0.32 and ipw3945-1.2.0 on a Thinkpad T60 with dual core
> Intel Core CPU. My root filesystem is XFS stored on an internal SATA
> disk, and I have 1GB of RAM and no swap.
> 
> After several suspend to RAM/resume cycles, the X interface got pretty
> slow today. Looking at the top output, I see that one core was
> completely busy in the "wa" state and according to `ps auxww`, the
> kswapd0 process was in uninterruptable deep sleep.
> 
> I don't use any swap because my applications rarely need more memory
> than I have in my system and using 1GB of swap yielded poor
> performance when it was actually accessed. I know I can tweak VM's
> preferences, but I simply don't feel the need to use swap when I have
> "plenty" of memory.

How much memory did you have in "cached" when you looked
with top (and no swap enabled) ?

If the amount of "cached" memory is very low, it could mean
that your shared libraries are being pushed out of memory,
instead of the kernel swapping out some page that belongs to
only one process.

As for kswapd getting into uninterruptible sleep state, it
will do that all by itself sometimes, without even having
any disk IO going on... that code looks a little suspect,
I will look into it.

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
