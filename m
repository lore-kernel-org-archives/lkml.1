Return-Path: <linux-kernel-owner+w=401wt.eu-S1753305AbZA0FPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbZA0FPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 00:15:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbZA0FO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 00:14:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751557AbZA0FO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 00:14:56 -0500
Date: Mon, 26 Jan 2009 21:13:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>, Dave Hansen <haveblue@us.ibm.com>,
       Eric Biederman <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Serge Hallyn <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Alan Cox <number6@the-village.bc.nu>,
       Ian Kent <raven@themaw.net>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] pids: kill now unused signal_struct-> __pgrp/__session
 and friends
Message-Id: <20090126211354.a4f38be2.akpm@linux-foundation.org>
In-Reply-To: <20090119220554.GA4219@redhat.com>
References: <20090118143354.GA8159@redhat.com>
	<20090119220554.GA4219@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2009 23:05:54 +0100 Oleg Nesterov <oleg@redhat.com> wrote:

> [PATCH -mm] pids: kill signal_struct-> __pgrp/__session and friends
> 
> (depends on pids-refactor-vnr-nr_ns-helpers-to-make-them-safe.patch)
> 
> We are wasting 2 words in signal_struct without any reason to implement
> task_pgrp_nr() and task_session_nr().
> 
> task_session_nr() has no callers since 2e2ba22ea4fd4bb85f0fa37c521066db6775cbef,
> we can remove it.
> 
> task_pgrp_nr() is still (I believe wrongly) used in fs/autofsX and fs/coda.
> 
> This patch reimplements task_pgrp_nr() via task_pgrp_nr_ns(), and kills
> __pgrp/__session and the related helpers.
> 
> The change in drivers/char/tty_io.c is cosmetic, but hopefully makes sense
> anyway.

hm, that's a fairly deep-looking patch.

You missed the fun bit:

 drivers/char/tty_io.c |    4 +--
 include/linux/sched.h |   43 +++++-----------------------------------
 kernel/exit.c         |   10 ++-------
 kernel/fork.c         |    2 -
 kernel/sys.c          |    4 ---
 5 files changed, 12 insertions(+), 51 deletions(-)

> TTY-parts-Acked-by: Alan Cox <number6@the-village.bc.nu>

who is that masked man?
