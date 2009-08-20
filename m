Return-Path: <linux-kernel-owner+w=401wt.eu-S1755017AbZHTWK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbZHTWK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 18:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754867AbZHTWK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 18:10:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45436 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754863AbZHTWK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 18:10:58 -0400
Date: Thu, 20 Aug 2009 15:10:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "tina.yang" <tina.yang@oracle.com>
Cc: jkosina@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysrq: add debug message to reboot event
Message-Id: <20090820151024.a60567c7.akpm@linux-foundation.org>
In-Reply-To: <4A8CB358.4090001@oracle.com>
References: <4A89AC97.6030109@oracle.com>
	<alpine.LNX.2.00.0908181339310.25797@wotan.suse.de>
	<20090819135827.168621d8.akpm@linux-foundation.org>
	<4A8CB358.4090001@oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Aug 2009 19:22:16 -0700
"tina.yang" <tina.yang@oracle.com> wrote:

> Add debug message to detect keyboard vs non-keyboard triggered sysrq-b events.
> This is to assist postmortem debugging on complicated computing setup with
> large number of applications involved where reboot event had occurred, but 
> unclear of its origin.

I'm still struggling to understand the motivation for the change. 
There are a large number of ways in which a machine can be rebooted,
all the way down to a triple-fault.  So it seems fairly arbitrary to
add additional information to discriminate between just two of those
ways.

I assume that somewhere in your setup you have a script which does
`echo b /proc/sysrq-trigger' and it took ages to work out that this was
happening and you felt that having this code in place would have
helped you debug that problem, yes?

If so, I wonder what is the likelihood that someone else will have the
same problem and will find this change useful.

Perhaps we should do this for all sysrq events rather than just sysrq-b?


> --- linux-2.6.18.i686/drivers/char/sysrq.c.orig	2009-08-13 10:55:57.526459000 -0700
> +++ linux-2.6.18.i686/drivers/char/sysrq.c	2009-08-13 10:58:10.798739000 -0700

2.6.18 is truly ancient and this patch doesn't apply at all to
current development kernels.

