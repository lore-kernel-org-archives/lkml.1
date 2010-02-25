Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933208Ab0BYSQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 13:16:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932876Ab0BYSQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 13:16:11 -0500
Date: Thu, 25 Feb 2010 19:14:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Neil Horman <nhorman@tuxdriver.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 0/2] umh && creds: kill sub_info->cred
Message-ID: <20100225181454.GA18000@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(on top of kmod-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limit.patch)

David, all.

I was going to do some minor fixes in kmod.c, but looking at this
code I am really puzzled by subprocess_info->cred complications.
I know absoulutely nothing about creds/keys, but at first glance
this all looks completely unnecessary?

IOW, please review these 2 simple patches. And sorry, I have no
idea how to really test these changes.


In case you are not aware of recent call_usermodehelper() changes
in -mm: struct subprocess_info has the new members,

	int (*init)(struct subprocess_info *info);
	void (*cleanup)(struct subprocess_info *info);
	void *data;

info->init() is called by ____call_usermodehelper() right before kernel_execve(),
info->cleanup() is called by call_usermodehelper_freeinfo().
info->data is obvious.

And we have the new helper, call_usermodehelper_setfns(init, cleanup, data)
which merely initializes these members.

Oleg.

