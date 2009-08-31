Return-Path: <linux-kernel-owner+w=401wt.eu-S1753005AbZHaP7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbZHaP7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 11:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbZHaP7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 11:59:20 -0400
Received: from www.tglx.de ([62.245.132.106]:57598 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbZHaP7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 11:59:19 -0400
Date: Mon, 31 Aug 2009 17:59:00 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/core] clocksource: Resolve cpu hotplug dead lock
 with TSC unstable
In-Reply-To: <20090831101928.4c00c797@skybase>
Message-ID: <alpine.LFD.2.00.0908311754590.19335@localhost.localdomain>
References: <new-submission> <tip-7285dd7fd375763bfb8ab1ac9cf3f1206f503c16@git.kernel.org> <20090831101928.4c00c797@skybase>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Aug 2009, Martin Schwidefsky wrote:
> Ah, very good. I've been going round in circles to find a solution that
> allows to  downgrade the tsc rating when the second cpu is enabled.
> Could not find a solution. Your approach changes semantics slightly:
> the tsc clock will continue with its old rating for a while until the
> watchdog will do the downgrade. If that is acceptable then this is a
> good solution.

Even the old code did not switch right away. The TSC was used until
the next timer interrupt. Also we survive the detection of unstable
TSCs with the watchdog which can happen quite after the fact that it
became unusable. The important point is that we detect it at all and
replace it with something useable.

Thanks,

	tglx
