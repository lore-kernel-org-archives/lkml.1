Return-Path: <linux-kernel-owner+w=401wt.eu-S1758001AbXKZSTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001AbXKZSTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 13:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755565AbXKZSTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 13:19:45 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:33479 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754193AbXKZSTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 13:19:44 -0500
Date: Mon, 26 Nov 2007 21:20:08 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH? 3/3] move daemonized kernel threads into the swapper's session
Message-ID: <20071126182008.GA17587@tv-sign.ru>
References: <20071126142556.GA16531@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071126142556.GA16531@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26, Oleg Nesterov wrote:
>
> Any reason why daemonized kthread still uses 1,1 special pids?

Actually, I guess the reason is that this was not possible before.
Now that set_special_pids uses "struct pid" we can do this.

Perhaps it is better to move the callsite to reparent_to_kthreadd()
and kill set_sepcial_pids().

Oleg.

