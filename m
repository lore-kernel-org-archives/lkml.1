Return-Path: <linux-kernel-owner+w=401wt.eu-S1753998AbYIDTSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbYIDTSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 15:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbYIDTSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 15:18:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753689AbYIDTSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 15:18:01 -0400
Date: Thu, 4 Sep 2008 12:16:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: yhlu.kernel@gmail.com, tglx@linutronix.de, hpa@zytor.com,
       jbarnes@virtuousgeek.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: split e820 reserved entries record to late v4 -
 fix v7
Message-Id: <20080904121627.bc182da7.akpm@linux-foundation.org>
In-Reply-To: <20080904190457.GB24990@elte.hu>
References: <1220254284-29532-1-git-send-email-yhlu.kernel@gmail.com>
	<20080904190457.GB24990@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2008 21:04:57 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> +		printk(KERN_DEBUG "    __reserve_region_with_split: (%s) [%llx, %llx], res: (%s) [%llx, %llx]\n",
> +			 conflict->name, conflict->start, conflict->end,
> +			 name, start, end);

start and end have type resource_size_t.  Such types CANNOT be printed
unless cast to a known type.

Because there is a %s following an incorrect %lld, the above code will
crash the machine.

