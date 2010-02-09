Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab0BIGIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 01:08:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753403Ab0BIGIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 01:08:35 -0500
Date: Mon, 8 Feb 2010 22:07:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/2] allow printk delay after multi lines
Message-Id: <20100208220753.61a39bab.akpm@linux-foundation.org>
In-Reply-To: <a8e1da1002082156s3145a775o7424bc47ac503636@mail.gmail.com>
References: <20100206134056.GB2562@darkstar>
	<20100208135654.04b79bbc.akpm@linux-foundation.org>
	<a8e1da1002081831j6fdea8a7v41cc07b635ab7dda@mail.gmail.com>
	<a8e1da1002082156s3145a775o7424bc47ac503636@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Feb 2010 13:56:34 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:

> BTW, for the sysctl variables. I found in kernel.h there's:
> printk/console_loglevel/panic related extern variables for sysctl.
> 
> console_loglevel and panic related variables are used here and there,
> not just for sysctl, so I think it should stay in kernel.h.
> 
> The printk related variables for sysctl and all the extern variables in
> sysctl.c can be move to sysctl.h. Seems no need new head file.
> 
> Andrew, what's your opinion?

Symbols which are defined in printk.c and which are used in other
compilation units should be declared in printk.h!

We mucked up in the past by putting these things in kernel.h and as
externs in sysctl.c, but that's no reason to continue to do so.  As a
special-case, it makes convenience sense to declare printk() itself and
the loglevel strings etc in kernel.h, but that _is_ a special case.



