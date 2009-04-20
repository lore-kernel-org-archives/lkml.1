Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbZDTTmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbZDTTmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 15:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753542AbZDTTm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 15:42:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47872 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751356AbZDTTm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 15:42:26 -0400
Date: Mon, 20 Apr 2009 12:30:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH 3/4] tracing: fix recursive test level calculation
Message-Id: <20090420123034.ffa17e14.akpm@linux-foundation.org>
In-Reply-To: <20090420174017.997451662@goodmis.org>
References: <20090420173819.957332585@goodmis.org>
	<20090420174017.997451662@goodmis.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Apr 2009 13:38:22 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

>  static int trace_irq_level(void)
>  {
> -	return hardirq_count() + softirq_count() + in_nmi();
> +	return (hardirq_count() >> HARDIRQ_SHIFT) +
> +		(softirq_count() >> + SOFTIRQ_SHIFT) +
> +		!!in_nmi();
>  }

hah, tricked you!

IMO hardirq_count() and softirq_count() should do the shift internally.
They're terribly misleading at present.
