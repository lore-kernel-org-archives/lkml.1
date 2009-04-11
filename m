Return-Path: <linux-kernel-owner+w=401wt.eu-S1753914AbZDKAYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbZDKAYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 20:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbZDKAX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 20:23:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36515 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752038AbZDKAXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 20:23:55 -0400
Date: Fri, 10 Apr 2009 17:22:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jack Steiner <steiner@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 03/13] GRU - dynamic allocation of kernel contexts
Message-Id: <20090410172243.d60a43d5.akpm@linux-foundation.org>
In-Reply-To: <20090410132418.GB18113@sgi.com>
References: <20090406160809.278924000@sgi.com>
	<20090406161011.887146000@sgi.com>
	<20090409153709.96fb4d96.akpm@linux-foundation.org>
	<20090410132418.GB18113@sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Apr 2009 08:24:18 -0500
Jack Steiner <steiner@sgi.com> wrote:

> +			mutex_unlock(&gts->ts_ctxlock);
> +			set_current_state(TASK_INTERRUPTIBLE);
>  			schedule_timeout(GRU_ASSIGN_DELAY);  /* true hack ZZZ */

OK...  But if the calling task has signal_pending(), the
schedule_timeout() will return immediately.

If that's a problem then perhaps use plain old msleep()?
