Return-Path: <linux-kernel-owner+w=401wt.eu-S1752562AbZLBJFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbZLBJFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 04:05:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbZLBJFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 04:05:37 -0500
Received: from mail.gmx.net ([213.165.64.20]:56206 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750894AbZLBJFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 04:05:36 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+6Y1dMEwq6b5trEnm51zerXspiob/yGPsKrDI4KQ
	a1WHJjadzJ4X4Z
Subject: Re: [PATCH 3/7] sched: refactor try_to_wake_up()
From: Mike Galbraith <efault@gmx.de>
To: Tejun Heo <tj@kernel.org>
Cc: tglx@linutronix.de, mingo@elte.hu, avi@redhat.com, peterz@infradead.org,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
In-Reply-To: <1259726212-30259-4-git-send-email-tj@kernel.org>
References: <1259726212-30259-1-git-send-email-tj@kernel.org>
	 <1259726212-30259-4-git-send-email-tj@kernel.org>
Content-Type: text/plain
Date: Wed, 02 Dec 2009 10:05:33 +0100
Message-Id: <1259744733.6028.233.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-02 at 12:56 +0900, Tejun Heo wrote:
> Factor ttwu_activate() and ttwu_woken_up() out of try_to_wake_up().

Nit: ttwu_woken_up() sounds decidedly strange to my ear. Perhaps
ttwu_post_activation()?

As a $.02 comment, factoring here doesn't look nice, reader scrolls
around whereas he currently sees all the why/wherefore at a glance.
Needing to pass three booleans for stats also looks bad.  I think it
would _look_ better with the thing just duplicated/stripped down and
called what it is, sched_notifier_wakeup() or such.

Which leaves growth in it's wake though...

> +/**
>   * try_to_wake_up - wake up a thread
>   * @p: the to-be-woken-up thread

Nit: thread to be awakened sounds better.

	-Mike

