Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab0BRIXL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 03:23:11 -0500
Received: from one.firstfloor.org ([213.235.205.2]:33058 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab0BRIXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 03:23:06 -0500
To: Luca Barbieri <luca@luca-barbieri.com>
Cc: mingo@elte.hu, hpa@zytor.com, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/10] x86-32: use SSE for atomic64_read/set if available
From: Andi Kleen <andi@firstfloor.org>
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
	<1266406962-17463-10-git-send-email-luca@luca-barbieri.com>
Date: Thu, 18 Feb 2010 09:23:02 +0100
In-Reply-To: <1266406962-17463-10-git-send-email-luca@luca-barbieri.com> (Luca Barbieri's message of "Wed, 17 Feb 2010 12:42:41 +0100")
Message-ID: <87eikj54wp.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luca Barbieri <luca@luca-barbieri.com> writes:

> This patch uses SSE movlps to perform 64-bit atomic reads and writes.

You seem to have forgotten to add benchmark results that show this is
actually worth while? And is there really any user on 32bit
that needs 64bit atomic_t?

I have to agree with Peter on it being a bad idea very likely
to mess with FPU state like this.

I'm also suspicious of your use of global register variables.
This means they won't be saved on entry/exit of the functions.
Does that really work?

It's also a not widely used gcc feature and those are always
somewhat risky.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
