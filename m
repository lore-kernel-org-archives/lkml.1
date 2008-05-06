Return-Path: <linux-kernel-owner+w=401wt.eu-S1765468AbYEFTbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765468AbYEFTbW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 15:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757409AbYEFTbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 15:31:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40424 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757194AbYEFTbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 15:31:05 -0400
Date: Tue, 6 May 2008 12:24:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: paulmck@us.ibm.com, joe@perches.com, davem@davemloft.net,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm][v2] ratelimit rewrite
Message-Id: <20080506122423.051b4254.akpm@linux-foundation.org>
In-Reply-To: <20080506022558.GA2904@darkstar.te-china.tietoenator.com>
References: <20080506022558.GA2904@darkstar.te-china.tietoenator.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008 10:25:58 +0800
Dave Young <hidave.darkstar@gmail.com> wrote:

> [Fixed a macro error found by davem, added more changes description.]
> 
> ---
> All ratelimit user use same jiffies and burst params, so some messages
> (callbacks) will be lost.
> 
> For example:
> a call printk_ratelimit(5 * HZ, 1)
> b call printk_ratelimit(5 * HZ, 1) before the 5*HZ timeout of a, then b will
> will be supressed.
> 
> Changes:
> 1. rewrite __ratelimit, and use a ratelimit_state as parameter.
>    Thanks for hints from andrew.
> 2. change WARN_ON_SECS to WARN_ON_RATELIMIT, update rcupreempt.h
> 3. remove __printk_ratelimit
> 4. use __ratelimit in net_ratelimit

I rebased this on top of mainline+linux-next+mm-stuff.  I'll drop
add-warn_on_secs-macro.patch and use-warn_on_secs-in-rcupreempth.patch
