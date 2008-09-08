Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529AbYIHVRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbYIHVRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 17:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754038AbYIHVRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 17:17:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41667 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753958AbYIHVRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 17:17:13 -0400
Date: Mon, 8 Sep 2008 14:16:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Menage <menage@google.com>
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
Subject: Re: [PATCH] cgroup(fix critical bug): new handling for tasks file
Message-Id: <20080908141635.3ce77adc.akpm@linux-foundation.org>
In-Reply-To: <48C0C4F7.2080702@google.com>
References: <48B360CE.2010501@cn.fujitsu.com>
	<6599ad830808251929p10dfc9d2ub11e4db0cd4f9f3@mail.gmail.com>
	<48B39319.7070403@cn.fujitsu.com>
	<6599ad830808261544w308a850m865ac0c0a1552c77@mail.gmail.com>
	<48B4D81D.2040200@cn.fujitsu.com>
	<6599ad830808270536i353e1807kaac4e9fb74301bb0@mail.gmail.com>
	<48B69582.4000208@cn.fujitsu.com>
	<48C0C4F7.2080702@google.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Sep 2008 22:34:47 -0700
Paul Menage <menage@google.com> wrote:

>  	npids = cgroup_task_count(cgrp);
> +	pidarray = kmalloc(npids * sizeof(pid_t), GFP_KERNEL);

kmalloc becomes more unreliable above 32 kbytes and 100% unreliable
above MAX_ORDER.

