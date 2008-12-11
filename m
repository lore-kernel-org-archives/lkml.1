Return-Path: <linux-kernel-owner+w=401wt.eu-S1759303AbYLKXLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759303AbYLKXLE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 18:11:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757049AbYLKXKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 18:10:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755628AbYLKXKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 18:10:51 -0500
Date: Thu, 11 Dec 2008 15:10:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: hidehiro.kawai.ez@hitachi.com, kosaki.motohiro@jp.fujitsu.com,
       linux-kernel@vger.kernel.org, roland@redhat.com,
       yumiko.sugita.yf@hitachi.com, satoshi.oshima.fk@hitachi.com
Subject: Re: [PATCH] coredump_filter: enable to change the default filter
Message-Id: <20081211151003.00572e04.akpm@linux-foundation.org>
In-Reply-To: <20081211154349.5000.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <4940B426.6040509@hitachi.com>
	<20081211154349.5000.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2008 15:46:49 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Hi
> 
> > This patch introduces new kernel parameter `coredump_filter'.
> > Setting a value to this parameter causes the default bitmask
> > of coredump_filter to be changed.
> > 
> > It is useful for users to change coredump_filter settings for
> > the whole system at boot time.  Without this parameter, users
> > have to change coredump_filter settings for each /proc/<pid>/
> > in an initializing script.
> 
> I think this patch only useful on following situation, right?
> 
>   - Administrator can't change rc script.
>   - Administrator can change boot parameter.
> 
> 
> When happen above situation?
> or, you intent to init process debugging?

Yes, this can be implemented in userspace by setting init's filter
before init forks any other processes.

I can understand the practical problems with that form of implementation
however :(


Or does the patch change other behaviour?  Say, when mm_init() is
called by a kernel thread (current->mm==NULL)?  call_usermodehelper(),
for example?

If so, then setting init's filter doesn't cover that case.
