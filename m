Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbZGAN6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbZGAN6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 09:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbZGAN60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 09:58:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51332 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742AbZGAN60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 09:58:26 -0400
Date: Wed, 1 Jul 2009 15:55:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: wait_task_zombie plus WNOWAIT question
Message-ID: <20090701135544.GA24374@redhat.com>
References: <87eit0h66p.wl%vmayatsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eit0h66p.wl%vmayatsk@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01, Vitaly Mayatskikh wrote:
>
> I'm working on (sigh) next version of wait_task_* cleanups and stuck
> in wait_task_zombie. I'm trying to move put_user(stat, wo->wo_stat)
> code from all wait_task_* functions to common place, but
> wait_task_zombie does not fill wo_stat if WNOWAIT flag is set

Only waitid() can use WNOWAIT, and in this case ->wo_stat == NULL.

> and does
> it w/o that flag. Is it done so by design, or I can make
> user-visible change and add put_user in WNOWAIT path?

Just check do not do put_user(->wo_stat) if it is NULL in do_wait
pathes.

Oleg.

