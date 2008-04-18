Return-Path: <linux-kernel-owner+w=401wt.eu-S1761244AbYDRUQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761244AbYDRUQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 16:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbYDRUQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 16:16:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40107 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751596AbYDRUQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 16:16:24 -0400
Date: Fri, 18 Apr 2008 13:15:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rostedt@goodmis.org,
       peterz@infradead.org, sandmann@redhat.com, pq@iki.fi,
       srostedt@redhat.com
Subject: Re: [PATCH 1/5] ftrace: simple clean ups
Message-Id: <20080418131535.dbcd315d.akpm@linux-foundation.org>
In-Reply-To: <20080418200849.968033091@goodmis.org>
References: <20080418200538.788522018@goodmis.org>
	<20080418200849.968033091@goodmis.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008 16:05:39 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> -	r = snprintf(buf, 64, "%ld\n",
> +	r = snprintf(buf, sizeof(buf), "%ld\n",

If you use scnprintf here

>  		     *ptr == (unsigned long)-1 ? -1 : nsecs_to_usecs(*ptr));
> -	if (r > 64)
> -		r = 64;
> +	if (r > sizeof(buf))
> +		r = sizeof(buf);

This becomes a cant-happen (I think).

