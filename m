Return-Path: <linux-kernel-owner+w=401wt.eu-S1756448AbYJUX6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448AbYJUX6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 19:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbYJUX6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 19:58:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57705 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752194AbYJUX6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 19:58:41 -0400
Date: Tue, 21 Oct 2008 16:58:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH 01/31] proc: switch /proc/loadavg to seq_file
Message-Id: <20081021165822.8d574935.akpm@linux-foundation.org>
In-Reply-To: <20081017123958.GB22653@x200.localdomain>
References: <20081017123958.GB22653@x200.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Oct 2008 16:39:58 +0400
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> and move it to fs/proc/loadavg.c while I'm at it.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
>  fs/proc/Makefile    |    2 +-
>  fs/proc/loadavg.c   |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/proc/proc_misc.c |   26 --------------------------

While I think the patchset is a good thing, this is absolutely the worst
possible time to merge large code-motion changes into linux-next.  We
need to maintain this stuff for more than two months, and everyone and
his puppy is altering those files.  Today's linux-next already broke.

So I'd suggest that this all be deferred until the day before
2.6.29-rc1(!).


fs/proc/meminfo.c: In function 'meminfo_proc_show':
fs/proc/meminfo.c:90: error: 'NR_ACTIVE' undeclared (first use in this function)
fs/proc/meminfo.c:90: error: (Each undeclared identifier is reported only once
fs/proc/meminfo.c:90: error: for each function it appears in.)
fs/proc/meminfo.c:91: error: 'NR_INACTIVE' undeclared (first use in this function)
