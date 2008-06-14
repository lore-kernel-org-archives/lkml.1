Return-Path: <linux-kernel-owner+w=401wt.eu-S1754599AbYFNQQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbYFNQQV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 12:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbYFNQQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 12:16:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:33547 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbYFNQQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 12:16:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=xHfUoGm6hUjYSL0H8OuVCNAeB4wZxmJGm2ClYJwZFF8EVuBeFu5yIEY+uia4Fk7vuC
         LZPru6SMHxIl9YcqjcYitMNwWERUtVxOI8OzOPh+n6xKqLWh+jelnRUVJ2E/P1BWbIau
         qeKkXBoH/KnBIdwMlQgQ045DK6MB4pwij/YCs=
Message-ID: <84144f020806140916j7c39d3fr6ada38169ebc84c2@mail.gmail.com>
Date: Sat, 14 Jun 2008 19:16:11 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Eduard - Gabriel Munteanu" <eduard.munteanu@linux360.ro>
Subject: Re: [PATCH 2/3] relay: Fix race condition which occurs when reading across CPUs.
Cc: "Tom Zanussi" <tzanussi@gmail.com>, akpm@linux-foundation.org,
       compudj@krystal.dyndns.org, linux-kernel@vger.kernel.org,
       righi.andrea@gmail.com
In-Reply-To: <20080614181103.17617db1@linux360.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080613040958.4f52ee29@linux360.ro>
	 <1213417601.8237.37.camel@charm-linux>
	 <20080614181103.17617db1@linux360.ro>
X-Google-Sender-Auth: b56a2fe1c97aa385
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2008 23:26:41 -0500
Tom Zanussi <tzanussi@gmail.com> wrote:
>> Alternatively, you could get rid of the problem by making sure CPU0
>> never reads CPU1's data, by having the userspace reader use per-cpu
>> threads and using sched_setaffinity() to pin each thread to a given
>> cpu. See for example, the blktrace code, which does this.

On Sat, Jun 14, 2008 at 6:11 PM, Eduard - Gabriel Munteanu
<eduard.munteanu@linux360.ro> wrote:
> Yes, and performance-wise this is better. Though I'm not sure setting
> affinity is 100% safe. Will the thread be migrated soon enough, so we
> don't read cross-CPU? The point is I'm not sure how hard this is
> enforced.
>
> However, I suggest this patch should go in, for two reasons:
> 1. It provides expected behavior in any such situation.
> 2. It adds (almost) no overhead when used in conjuction with setting CPU
> affinity. When the writer acquires the spinlock, it does not busy-wait,
> so the spinlock just disables IRQs (relay_write()).

Agreed. Tom, any objections to merging this patch?
