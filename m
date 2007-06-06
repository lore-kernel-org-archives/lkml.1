Return-Path: <linux-kernel-owner+w=401wt.eu-S965131AbXFFGzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965131AbXFFGzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 02:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757754AbXFFGzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 02:55:04 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57828 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757434AbXFFGzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 02:55:02 -0400
Date: Tue, 5 Jun 2007 23:54:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] kernel/sched{,_fair}.c: make code static
Message-Id: <20070605235441.7b132e27.akpm@linux-foundation.org>
In-Reply-To: <20070605215056.GJ5500@stusta.de>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
	<20070605215056.GJ5500@stusta.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2007 23:50:56 +0200 Adrian Bunk <bunk@stusta.de> wrote:

> This patch makes some needlessly global code static.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> ---
> 
> BTW: Please don't #include C files in sched.c

Yeah.

> -long div64_s(s64 divident, unsigned long divisor)
> +static long div64_s(s64 divident, unsigned long divisor)

"divident" does appear to be a word, but I suspect "dividend" was intended.

Why is this function lurking in the CPU scheduler rather than in
lib/somewhere.c?

Doesn't an unsigned divide give the same result as a signed one?
