Return-Path: <linux-kernel-owner+w=401wt.eu-S1753673AbYHSMFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673AbYHSMFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 08:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbYHSMEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 08:04:52 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:60251 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbYHSMEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 08:04:51 -0400
Message-ID: <48AAB693.8080906@s5r6.in-berlin.de>
Date: Tue, 19 Aug 2008 14:03:31 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Kevin Diggs <kevdig@hypersurf.com>
CC: linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [Fwd: Corrections please ...]
References: <48AA27AF.9070407@hypersurf.com> <20080819024125.GM19760@disturbed> <48AA7F47.5050805@hypersurf.com>
In-Reply-To: <48AA7F47.5050805@hypersurf.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Diggs wrote:
> Files attached this time ...

Alas several MUAs don't quote attachments in replies.  Hence the optimum
would be if you use a MUA which allows to insert text files without
whitespace change.

Also, when you respond on LKML, always use "reply to all" to keep
previous responders in a thread Cc'd.  This is necessary due to the high
volume of LKML, and in order to not force people to subscribe to LKML.


> --- include/linux/completion.h.orig	2008-08-13 00:56:52.000000000 -0700
> +++ include/linux/completion.h	2008-08-18 13:00:23.000000000 -0700
> @@ -10,6 +10,16 @@
>  
>  #include <linux/wait.h>
>  
> +/**
> + * struct completion - structure used to maintain state for a "completion"
> + * @done:  counting variable used to signal completion
> + * @wait:  internal wait queue head; used for locking and synchronization
> + *
> + * This is the structure used to maintain the state for a "completion". See
> + * also:  complete(), wait_for_completion() (and friends _timeout,
> + * _interruptible, _interruptible_timeout, and _killable), init_completion(),
> + * and macros DECLARE_COMPLETION() and INIT_COMPLETION().
> + */
>  struct completion {
>  	unsigned int done;
>  	wait_queue_head_t wait;

.done and .wait are not public AFAIU and should therefore not be
documented as an API.


> @@ -36,6 +46,13 @@
>  # define DECLARE_COMPLETION_ONSTACK(work) DECLARE_COMPLETION(work)
>  #endif
>  
> +/**
> + * init_completion: - Initialize a dynamically allocated completion
> + * @x:  completion structure that is to be initialized
> + *
> + * This inline function will initialize a dynamically created completion
> + * structure.
> + */
>  static inline void init_completion(struct completion *x)
>  {
>  	x->done = 0;

The last sentence is redundant and should be omitted.
-- 
Stefan Richter
-=====-==--- =--- =--==
http://arcgraph.de/sr/
