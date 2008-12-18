Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1751406AbYLRCjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406AbYLRCjm (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 21:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750746AbYLRCj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 21:39:29 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52263 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbYLRCj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 21:39:28 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sys_execve and sys_uselib do not call into fsnotify
Cc: kosaki.motohiro@jp.fujitsu.com, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, hch@infradead.org
In-Reply-To: <20081217150300.fafcdda8.akpm@linux-foundation.org>
References: <1229540000.3384.40.camel@localhost.localdomain> <20081217150300.fafcdda8.akpm@linux-foundation.org>
Message-Id: <20081218113729.6168.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu, 18 Dec 2008 11:39:23 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 17 Dec 2008 13:53:20 -0500
> Eric Paris <eparis@redhat.com> wrote:
> 
> > sys_execve and sys_uselib do not call into fsnotify so inotify does not get
> > open events for these types of syscalls.  This patch simply makes the
> > requisite fsnotify calls.
> 
> These two functions are grovelling around in pretty low-level fs
> operations.  One wonders whether they could be converted (ie: cleaned
> up) to use do_sys_open() or some other such higher-level thing.
> 
> That way, this fsnotify bug would be magically fixed, too.

hmm..

In current implementaion, do_sys_open() call fd_install().
then, it cause /proc/{pid}/fd entry change. iow, compatibility break.

Yup, it is fixable. but I think Eric's implementation is simpler.



