Return-Path: <linux-kernel-owner+w=401wt.eu-S1753664AbYKZEB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbYKZEB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 23:01:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbYKZEBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 23:01:49 -0500
Received: from waste.org ([66.93.16.53]:37474 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbYKZEBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 23:01:48 -0500
Subject: Re: [PATCH] random: add a way to get some random bits into the
	entropy pools early on
From: Matt Mackall <mpm@selenic.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20081125132600.5112fb24@infradead.org>
References: <20081125132600.5112fb24@infradead.org>
Content-Type: text/plain
Date: Tue, 25 Nov 2008 15:41:22 -0600
Message-Id: <1227649282.3196.3.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-25 at 13:26 -0800, Arjan van de Ven wrote:
> >From 5b3b09ac82316c2d4000460d586ebe59303c12c2 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Tue, 25 Nov 2008 11:41:37 -0800
> Subject: [PATCH] random: add a way to get some random bits into the entropy pools early on
> 
> currently the entropy pool gets seeded on the module_init() level, but there
> is at least one consumer of random bits (the oops ID that is printed as part
> of the oops).
> As a result of this, kerneloops.org is seeing a lot of oopses that all share
> the same 'random' number; which used to get filed away as "duplicate".
> 
> This patch adds a function to the random driver so that various pieces of
> the kernel can add random bits (but not entropy!) to the pool, to avoid
> this dupicate ID problem.

This appears to be equivalent to making random initialize earlier,
except with more code?

If we're going down a route like this, I'd like to see the ability to
actually mix in data (ie MAC addresses, DMI data, etc.) rather than just
timing.

-- 
Mathematics is the supreme nostalgia of our time.

