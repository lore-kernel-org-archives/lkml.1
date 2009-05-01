Return-Path: <linux-kernel-owner+w=401wt.eu-S1762331AbZEADJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762331AbZEADJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 23:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756269AbZEADJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 23:09:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754201AbZEADJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 23:09:35 -0400
Date: Thu, 30 Apr 2009 20:06:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 3/3] ring-buffer: make cpu buffer entries counter atomic
Message-Id: <20090430200607.9fc386ae.akpm@linux-foundation.org>
In-Reply-To: <20090501022403.826182932@goodmis.org>
References: <20090501022210.851418183@goodmis.org>
	<20090501022403.826182932@goodmis.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009 22:22:13 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:

> @@ -405,7 +405,7 @@ struct ring_buffer_per_cpu {
>  	unsigned long			nmi_dropped;
>  	unsigned long			commit_overrun;
>  	unsigned long			overrun;
> -	unsigned long			entries;
> +	atomic_t			entries;

This switches `entries' from unsigned-64-bit to signed-32-bit.

The signedness thing is just an unfortunate thing with atomic_t and probably
doesn't matter.

The change in size might or might not be a bug - that's for the person
who didn't document the data structure to work out ;)




/*
 * head_page == tail_page && head == tail then buffer is empty.
 */
struct ring_buffer_per_cpu {

the comment refers to vaporfields?
