Return-Path: <linux-kernel-owner+w=401wt.eu-S937046AbXGRAux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937046AbXGRAux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 20:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760615AbXGRAui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 20:50:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43590 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757754AbXGRAuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 20:50:37 -0400
Date: Tue, 17 Jul 2007 17:50:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AFS: Fix file locking
Message-Id: <20070717175017.8b8a8976.akpm@linux-foundation.org>
In-Reply-To: <20070717124732.22619.34179.stgit@warthog.cambridge.redhat.com>
References: <20070717124732.22619.34179.stgit@warthog.cambridge.redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007 13:47:32 +0100
David Howells <dhowells@redhat.com> wrote:

> +	if (type == AFS_LOCK_READ &&
> +	    vnode->flags & (1 << AFS_VNODE_READLOCKED)) {

Here we use

	vnode->flags & (1 << foo)

> +		set_bit(AFS_VNODE_LOCKING, &vnode->flags);

and elsewhere we use set_bit(foo, &vnode->flags) and clear_bit()

This is a bit strange.  Does the open-coded bit-test have any performance
benefit on any architecture?  Not on x86 at least, afaik.

Please consider converting all that stuff to test_bit() sometime.  It sure
would look a lot better.

