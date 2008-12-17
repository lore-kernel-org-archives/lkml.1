Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752570AbYLQXEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbYLQXEA (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 18:04:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbYLQXDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 18:03:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40384 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752306AbYLQXDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 18:03:50 -0500
Date: Wed, 17 Dec 2008 15:03:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com,
        hch@infradead.org
Subject: Re: [PATCH] sys_execve and sys_uselib do not call into fsnotify
Message-Id: <20081217150300.fafcdda8.akpm@linux-foundation.org>
In-Reply-To: <1229540000.3384.40.camel@localhost.localdomain>
References: <1229540000.3384.40.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2008 13:53:20 -0500
Eric Paris <eparis@redhat.com> wrote:

> sys_execve and sys_uselib do not call into fsnotify so inotify does not get
> open events for these types of syscalls.  This patch simply makes the
> requisite fsnotify calls.

These two functions are grovelling around in pretty low-level fs
operations.  One wonders whether they could be converted (ie: cleaned
up) to use do_sys_open() or some other such higher-level thing.

That way, this fsnotify bug would be magically fixed, too.
