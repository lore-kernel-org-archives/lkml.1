Return-Path: <linux-kernel-owner+w=401wt.eu-S1756848AbYA2XDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbYA2XDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 18:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbYA2XDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 18:03:01 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52393 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750794AbYA2XDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 18:03:00 -0500
Date: Tue, 29 Jan 2008 15:02:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: ebiederm@xmission.com, mingo@elte.hu, paulmck@linux.vnet.ibm.com,
       xemul@openvz.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix tasklist + find_pid() with CONFIG_PREEMPT_RCU
Message-Id: <20080129150209.663538cb.akpm@linux-foundation.org>
In-Reply-To: <20080129164019.GA2060@tv-sign.ru>
References: <20080129164019.GA2060@tv-sign.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2008 19:40:19 +0300
Oleg Nesterov <oleg@tv-sign.ru> wrote:

> With CONFIG_PREEMPT_RCU read_lock(tasklist_lock) doesn't imply rcu_read_lock(),

I'm suspecting that we have other code which assumes that read_lock, write_lock
and spin_lock imply rcu_read_lock().

I wonder if there are any sane runtime checks we can put in there to find
such problems.
