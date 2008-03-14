Return-Path: <linux-kernel-owner+w=401wt.eu-S1754957AbYCNJqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbYCNJqs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 05:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbYCNJqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 05:46:37 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:49732 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752218AbYCNJqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 05:46:19 -0400
Date: Fri, 14 Mar 2008 10:44:45 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-kernel@vger.kernel.org, Hans-Christian Egtvedt <hcegtvedt@atmel.com>,
       Andrew Victor <avictor.za@gmail.com>
Subject: Re: [PATCH] at73c213: Fix DMA size at the end of DMA buffer
Message-ID: <20080314104445.32f4da40@hskinnemo-gx620.norway.atmel.com>
In-Reply-To: <20080310.234306.15242180.anemo@mba.ocn.ne.jp>
References: <20080310.234306.15242180.anemo@mba.ocn.ne.jp>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Mar 2008 09:44:46.0056 (UTC) FILETIME=[0989C680:01C885B8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2008 23:43:06 +0900 (JST)
Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:

> +		size = runtime->period_size * runtime->channels;
> +		if (next_period == runtime->periods - 1)
> +			size += (runtime->buffer_size % runtime->period_size)
> +				* runtime->channels;

Ow. That looks expensive. Isn't there any way we can force the client
to select sane values of buffer_size and period_size?

It seems like a reasonable demand that buffer_size is a multiple of
period_size, doesn't it?

Haavard
