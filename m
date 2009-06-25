Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbZFYVUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbZFYVUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 17:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbZFYVUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 17:20:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753021AbZFYVUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 17:20:34 -0400
Date: Thu, 25 Jun 2009 14:20:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard =?ISO-8859-1?Q?R=F6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       kwangwoo.lee@gmail.com, thierry.reding@avionic-design.de,
       soni.trilok@gmail.com
Subject: Re: [PATCH 1/2] tsc2007: remove HR timer
Message-Id: <20090625142010.bd656a9d.akpm@linux-foundation.org>
In-Reply-To: <4A40C288.2060702@mocean-labs.com>
References: <4A40C288.2060702@mocean-labs.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 13:54:48 +0200
Richard R__jfors <richard.rojfors.ext@mocean-labs.com> wrote:

> This patch removes the HR timer, since it's bad to do synchronous I2C
> in the HR timer callback context. The new implementation makes use
> of the global workqueue. The work is scheduled every 5ms when polling
> rather than 5 us.
> 

"it's bad" isn't a very good description of the problem which the patch
fixes.

This matters.  People wish to make decisions about whether this patch
is needed in 2.6.29.x, 2.6.30.x, 2.6.31, 2.6.32, etc.  Without knowing
the effects of the problem which the patch fixes, we cannot make that
decision!

> 
> +	/* cancel any work */
> +	cancel_delayed_work(&ts->work);
> +

Should this have been cancel_delayed_work_sync()?


/*
 * Kill off a pending schedule_delayed_work().  Note that the work callback
 * function may still be running on return from cancel_delayed_work(), unless
 * it returns 1 and the work doesn't re-arm itself. Run flush_workqueue() or
 * cancel_work_sync() to wait on it.
 */
static inline int cancel_delayed_work(struct delayed_work *work)



