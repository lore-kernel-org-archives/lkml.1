Return-Path: <linux-kernel-owner+w=401wt.eu-S1751330AbXBZMAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330AbXBZMAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 07:00:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbXBZMAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 07:00:41 -0500
Received: from mail.screens.ru ([213.234.233.54]:39553 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbXBZMAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 07:00:40 -0500
Date: Mon, 26 Feb 2007 15:00:43 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Pavel Machek <pavel@ucw.cz>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Aneesh Kumar <aneesh.kumar@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [RFC][PATCH 1/3] Freezer: Fix vfork problem
Message-ID: <20070226120043.GB234@tv-sign.ru>
References: <200702261139.59130.rjw@sisk.pl> <200702261147.12274.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702261147.12274.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26, Rafael J. Wysocki wrote:
>
> The changelog explains it pretty well, I hope, but I have one more comment to
> start with.  Namely, in this version of the patch I've added
> 
> +	if (is_user_space(current))
> +		try_to_freeze();
> 
> to freezer_count() instead of just try_to_freeze().  This way kernel threads
> can avoid being frozen where they don't want to.

In that case we should also modify ____call_usermodehelper(), otherwise we have
the same "deadlock" if it is frozen. But this is not so easy to do as I thought
before.

Oleg.

