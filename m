Return-Path: <linux-kernel-owner+w=401wt.eu-S1754455AbXDWWzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbXDWWzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 18:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754456AbXDWWzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 18:55:44 -0400
Received: from mail.screens.ru ([213.234.233.54]:38819 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754455AbXDWWzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 18:55:43 -0400
Date: Tue, 24 Apr 2007 02:55:35 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       ego@in.ibm.com, linux-kernel@vger.kernel.org, vatsa@in.ibm.com,
       paulmck@us.ibm.com, pavel@ucw.cz
Subject: Re: [RFC][PATCH -mm 2/3] freezer: Introduce freezer_flags
Message-ID: <20070423225535.GB659@tv-sign.ru>
References: <20070419120131.GB13435@in.ibm.com> <200704222139.27128.rjw@sisk.pl> <20070423222358.GA627@tv-sign.ru> <200704240040.18312.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704240040.18312.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24, Rafael J. Wysocki wrote:
>
> Should I clear it in dup_task_struct() or is there a better place?

I personally think we should do this in dup_task_struct(). In fact, I believe
it is better to replace the

	*tsk = *orig;

with some helper (like setup_thread_stack() below), and that helper clears
->freezer_flags. Say, copy_task_struct().

Oleg.

