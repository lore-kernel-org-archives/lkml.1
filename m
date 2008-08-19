Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbYHSTMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbYHSTMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 15:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756726AbYHSTM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 15:12:28 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:39366 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536AbYHSTM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 15:12:27 -0400
Message-ID: <48AB1A5B.3020305@cs.helsinki.fi>
Date: Tue, 19 Aug 2008 22:09:15 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, rdunlap@xenotime.net,
       mpm@selenic.com, tglx@linutronix.de, rostedt@goodmis.org,
       mathieu.desnoyers@polymtl.ca, tzanussi@gmail.com
Subject: Re: [PATCH 3/5] SLUB: Replace __builtin_return_address(0) with	_RET_IP_.
References: <1219167807-5407-1-git-send-email-eduard.munteanu@linux360.ro> <1219167807-5407-2-git-send-email-eduard.munteanu@linux360.ro> <1219167807-5407-3-git-send-email-eduard.munteanu@linux360.ro> <48AB0D69.4090703@linux-foundation.org> <20080819182423.GA5520@localhost> <48AB1769.3040703@linux-foundation.org>
In-Reply-To: <48AB1769.3040703@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
>  static void print_track(const char *s, struct track *t)
> @@ -399,7 +399,7 @@ static void print_track(const char *s, s
>  	if (!t->addr)
>  		return;
> 
> -	printk(KERN_ERR "INFO: %s in %pS age=%lu cpu=%u pid=%d\n",
> +	printk(KERN_ERR "INFO: %s in %lxS age=%lu cpu=%u pid=%d\n",
>  		s, t->addr, jiffies - t->when, t->cpu, t->pid);

This looks wrong. The '%pS' thingy has a special purpose:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=7daf705f362e349983e92037a198b8821db198af
