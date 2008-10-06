Return-Path: <linux-kernel-owner+w=401wt.eu-S1754854AbYJFGAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbYJFGAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 02:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbYJFGAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 02:00:25 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58851 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658AbYJFGAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 02:00:23 -0400
To: Kees Cook <kees.cook@canonical.com>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       Jakub Jelinek <jakub@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       libc-alpha@sourceware.org
Subject: Re: [PATCH] ELF: implement AT_RANDOM for future glibc use
From: Andi Kleen <andi@firstfloor.org>
References: <20081001201116.GD12527@outflux.net> <48E3EFD6.2010704@redhat.com>
	<20081001215657.GH12527@outflux.net>
	<20081001220948.GC32107@sunsite.ms.mff.cuni.cz>
	<20081001222706.68E7E1544B4@magilla.localdomain>
	<20081003001616.GN10632@outflux.net>
Date: Mon, 06 Oct 2008 08:00:21 +0200
In-Reply-To: <20081003001616.GN10632@outflux.net> (Kees Cook's message of "Thu, 2 Oct 2008 17:16:16 -0700")
Message-ID: <87ej2untze.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <kees.cook@canonical.com> writes:

> While discussing[1] the need for glibc to have access to random bytes
> during program load, it seems that an earlier attempt to implement
> AT_RANDOM got stalled.  This implements a configurable number of random
> bytes available to every ELF program via a new auxv AT_RANDOM vector.

While the basic idea is good using get_random_bytes() is not. 

That eats precious cryptography strength entropy from the entropy
pool, which on many systems is not adequately fed. In those cases you
really only want to use it for real keys, not for lower grade
applications. The applications glibc wants to use this for do not
really require crypto strength entropy, just relatively unpredictable
randomness.

What you should instead do is to initialize some other cryptographic RNG 
regularly and use the output of that.

-Andi
