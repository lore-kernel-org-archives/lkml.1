Return-Path: <linux-kernel-owner+w=401wt.eu-S1761081AbYBMXVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761081AbYBMXVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 18:21:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756440AbYBMXU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 18:20:59 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45312 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755593AbYBMXU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 18:20:58 -0500
Date: Wed, 13 Feb 2008 15:20:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: minyard@acm.org
Cc: linux-kernel@vger.kernel.org, openipmi-developer@lists.sourceforge.net
Subject: Re: [PATCH 3/8] IPMI: Run to completion fixes
Message-Id: <20080213152018.98d427c7.akpm@linux-foundation.org>
In-Reply-To: <20080213162342.GC9830@minyard.local>
References: <20080213162342.GC9830@minyard.local>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 10:23:42 -0600
Corey Minyard <minyard@acm.org> wrote:

> From: Corey Minyard <cminyard@mvista.com>
> 
> The "run_to_completion" mode was somewhat broken.  Locks need to be
> avoided in run_to_completion mode, and it shouldn't be used by normal
> users, just internally for panic situations.
> 
> This patch removes locks in run_to_completion mode and removes the
> user call for setting the mode.  The only user was the poweroff
> code, but it was easily converted to use the polling interface.
> 
> +	/*
> +	 * Spin until our message is done.
> +	 */
> +	while (atomic_read(&dummy_count) > 0) {
> +		ipmi_poll_interface(user);
> +		barrier();
> +	}

we'd normally use cpu_relax() here.


