Return-Path: <linux-kernel-owner+w=401wt.eu-S1752972AbZHSQMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972AbZHSQMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbZHSQMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:12:31 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:37444 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbZHSQMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:12:30 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH] Add minimal support for software performance counters
 for ia64
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: William Cohen <wcohen@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4A8C2290.3040707@redhat.com>
References: <4A8C2290.3040707@redhat.com>
Content-Type: text/plain
Date: Wed, 19 Aug 2009 18:12:31 +0200
Message-Id: <1250698351.8282.106.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-19 at 12:04 -0400, William Cohen wrote:
> +#ifdef __ia64__
> +#include "../../arch/ia64/include/asm/unistd.h"
> +#define rmb()          asm volatile("" ::: "memory")
> +#define cpu_relax()    asm volatile("" ::: "memory");
> +#endif

Surely the itanic has a real memory barrier? The kernel seems to use
something along the lines of mf.

Also, cpu_relax() seems to end up being asm volatile("hint @pause" :::
"memory"), although we don't seem to have an actual user of cpu_relax()
in perf atm.



