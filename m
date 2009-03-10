Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840AbZCJTFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbZCJTFn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 15:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbZCJTFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 15:05:33 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:63568 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbZCJTFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 15:05:33 -0400
Message-ID: <49B6B9D2.8000807@freescale.com>
Date: Tue, 10 Mar 2009 14:04:50 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, rdreier@cisco.com, jirislaby@gmail.com,
       peterz@infradead.org, will.newton@gmail.com, hancockrwd@gmail.com,
       jeremy@goop.org
Subject: Re: [PATCH v4] introduce macro spin_event_timeout()
References: <1236699004-1863-1-git-send-email-timur@freescale.com> <fa686aa40903101141l33fbfc7cha0d2d85f6e1cb795@mail.gmail.com>
In-Reply-To: <fa686aa40903101141l33fbfc7cha0d2d85f6e1cb795@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely wrote:

> I typically use something in the form of this pattern on powerpc code
> when I absolutely have to busywait.
>     int end_ts = get_tbl() + some_delay;  /* note that this is signed */
>     while (end_ts - get_tbl() > 0)
>         if (condition)
>             break;

Funny you mention this, because I was just about to implement the same
thing.  Of course, it will be a PowerPC-only function, but I suppose
that's its fate regardless.

> This macro also looks like a tempting unbounded latency tarpit to fall
> into when people start using it in critical regions,  but that goes
> for code using a non-timed-out busywait also.

I can't fix everything!

-- 
Timur Tabi
Linux kernel developer at Freescale
