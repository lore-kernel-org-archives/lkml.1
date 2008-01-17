Return-Path: <linux-kernel-owner+w=401wt.eu-S1758390AbYAQWG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758390AbYAQWG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbYAQWGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:06:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44657 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715AbYAQWGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:06:48 -0500
Date: Thu, 17 Jan 2008 23:06:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: copy srat table and unmap in acpi_parse_table
Message-ID: <20080117220638.GA18883@elte.hu>
References: <200801171244.46228.yinghai.lu@sun.com> <20080117204343.GA32175@elte.hu> <200801171409.56611.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801171409.56611.yinghai.lu@sun.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> > Or if d8d28f25f33c6a03 really needs to be reverted to get your 
> > system to boot properly, which particular bit of it was causing 
> > trouble for you? (or the whole thing?)
> 
> we need to call acpi_os_unmap_memory in acpi_table_parse or just after 
> it.
> 
> call it in acpi_table_parse is much cleaner

agreed - i had a second look at your patch and it's much cleaner.

> the problem is that acpi_numa_slit_init do bad assumaption that it 
> still can use address after it's callback function. so we need to copy 
> the slit.

ok. I've applied your patch and boot-tested it already - it should show 
up soon in the next x86.git drop.

	Ingo
