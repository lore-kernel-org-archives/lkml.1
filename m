Return-Path: <linux-kernel-owner+w=401wt.eu-S1751311AbXBZQIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311AbXBZQIg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 11:08:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbXBZQIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 11:08:36 -0500
Received: from mail.screens.ru ([213.234.233.54]:52978 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbXBZQIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 11:08:35 -0500
Date: Mon, 26 Feb 2007 19:11:29 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Pavel Machek <pavel@ucw.cz>,
       Aneesh Kumar <aneesh.kumar@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [RFC][PATCH 1/3] Freezer: Fix vfork problem
Message-ID: <20070226161129.GA527@tv-sign.ru>
References: <200702261139.59130.rjw@sisk.pl> <200702261147.12274.rjw@sisk.pl> <20070226120043.GB234@tv-sign.ru> <20070226151442.GA29869@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070226151442.GA29869@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26, Srivatsa Vaddagiri wrote:
>
> On Mon, Feb 26, 2007 at 03:00:43PM +0300, Oleg Nesterov wrote:
> > In that case we should also modify ____call_usermodehelper(), otherwise we have
> > the same "deadlock" if it is frozen. But this is not so easy to do as I thought
> > before.
> 
> Before ____call_usermodehelper can freeze, it should have entered userspace 
> right? By that time, its vfork parent should have definitely woken up,
> which should avoid the deadlock you point out?

Ah, yes, thanks for correcting me.

We are doing flush_old_exec() a way before entering userspace of course.

Oleg.

