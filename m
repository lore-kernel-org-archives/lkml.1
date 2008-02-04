Return-Path: <linux-kernel-owner+w=401wt.eu-S1755491AbYBDA22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbYBDA22 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 19:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbYBDA2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 19:28:18 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55375 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754039AbYBDA2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 19:28:17 -0500
Date: Sun, 3 Feb 2008 16:28:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH 3/4] Clean up the kill_someting_info
Message-Id: <20080203162820.880405c3.akpm@linux-foundation.org>
In-Reply-To: <479DF1D3.3080704@openvz.org>
References: <479DF1D3.3080704@openvz.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008 18:16:35 +0300 Pavel Emelyanov <xemul@openvz.org> wrote:

> This is the first stop (of two) in removing the kill_pgrp_info.
> 
> All the users of this function are in kernel/signal.c, but all
> they need is to call __kill_pgrp_info() with the tasklist_lock
> read-locked.
> 
> Fortunately, one of its users is the kill_something_info(),
> which already needs this lock in one of its branches, so clean
> these branches up and call the __kill_pgrp_info() directly.
> 
> Based on Oleg's view of how this function should look.

This patch causes my Fedora Core 3 x86_64 machine to fail.  When
rc.sys_init runs /sbin/start_udev a segmentation fault in start_udev is
reported and no device nodes are created.  This is the only one of my test
machines which behaves this way.

Config: http://userweb.kernel.org/~akpm/config-x.txt
Running udev-039-8.FC3
