Return-Path: <linux-kernel-owner+w=401wt.eu-S1757843AbYAQUo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757843AbYAQUo0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 15:44:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757078AbYAQUn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 15:43:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54657 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757558AbYAQUnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 15:43:55 -0500
Date: Thu, 17 Jan 2008 21:43:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: copy srat table and unmap in acpi_parse_table
Message-ID: <20080117204343.GA32175@elte.hu>
References: <200801171244.46228.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801171244.46228.yinghai.lu@sun.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0003]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> [PATCH] x86: copy srat table and unmap in acpi_parse_table
> 
> 
> the old acpi_numa_slit_init was saving old address in early stage 
> acpi_slit and acpi_parse_table can not unmap address that. the patch 
> copy the slit in the callback, so we could unmap table in 
> acpi_parse_table instead of outside track it.
> 
> need to revert
> "
> commit d8d28f25f33c6a035cdfb1d421c79293d16e5c58
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Thu Jan 17 15:26:42 2008 +0100
> 
>     x86: ACPI: fix mapping leaks
> 
>     ioremap_early() is stateful, hence we cannot tolerate mapping leaks.
> "
> 
> before appling this patch

do you mean your patch should be applied first, then the 
d8d28f25f33c6a03 patch should applied as second?

Or if d8d28f25f33c6a03 really needs to be reverted to get your system to 
boot properly, which particular bit of it was causing trouble for you? 
(or the whole thing?)

	Ingo
