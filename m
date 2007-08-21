Return-Path: <linux-kernel-owner+w=401wt.eu-S1752685AbXHUUQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbXHUUQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 16:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750844AbXHUUQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 16:16:11 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33444 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750747AbXHUUQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 16:16:10 -0400
Date: Tue, 21 Aug 2007 13:15:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ian Kent <raven@themaw.net>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>
Subject: Re: [PATCH] autofs4: reinstate negatitive timeout of mount fails
Message-Id: <20070821131551.4026fb96.akpm@linux-foundation.org>
In-Reply-To: <1187688369.3318.12.camel@raven.themaw.net>
References: <1187688369.3318.12.camel@raven.themaw.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2007 17:26:09 +0800
Ian Kent <raven@themaw.net> wrote:

> Due to a change to fs/dcache.c:d_lookup() in the 2.6 kernel whereby only
> hashed dentrys are returned the negative caching of mount failures
> stopped working in the autofs4 module for nobrowse mount (ie. directory
> created at mount time and removed at umount or following a mount
> failure).
> 
> This patch keeps track of the dentrys from mount fails in order to be
> able check the timeout since the last fail and return the appropriate
> status. In addition the timeout value is settable at load time as a
> module option and via sysfs using the module
> parameter /sys/module/autofs4/parameters/negative_timeout.

Boy, that's a complex-looking patch.  I think I'll sit on this one
for 2.6.24 ;)

It seems to use a lot of list_for_each[_safe] which could
have been coded as list_for_each_entry[_safe], btw.

