Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab0BRK0x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 05:26:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:57444 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859Ab0BRK0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 05:26:51 -0500
Subject: Re: [PATCH 08/10] x86-32: support atomic64_t on 386/486 UP/SMP
From: Peter Zijlstra <peterz@infradead.org>
To: Luca Barbieri <luca@luca-barbieri.com>
Cc: mingo@elte.hu, hpa@zytor.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1266406962-17463-9-git-send-email-luca@luca-barbieri.com>
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
	 <1266406962-17463-9-git-send-email-luca@luca-barbieri.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Feb 2010 11:25:46 +0100
Message-ID: <1266488746.26719.120.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-17 at 12:42 +0100, Luca Barbieri wrote:
> This patch makes atomic64 use either the generic implementation or
> the rewritten cmpxchg8b one just introduced by inserting a "call" to
> either, using the alternatives system to dynamically switch the calls.
> 
> This allows to use atomic64_t on 386/486 which lack cmpxchg8b

IIRC we dropped <i586 SMP support, and since we don't have a PMU on
those chips atomic64_t doesn't need to be NMI safe, so a simple
UP-IRQ-disable implementation should suffice.

