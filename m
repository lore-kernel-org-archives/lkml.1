Return-Path: <linux-kernel-owner+w=401wt.eu-S1752180AbZI1OPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbZI1OPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 10:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbZI1OPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 10:15:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:32815 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751397AbZI1OPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 10:15:22 -0400
Date: Mon, 28 Sep 2009 15:16:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, gregkh@suse.de,
       linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Remove pty_ops_bsd and pty_bsd_ioctl() as they're not
 used
Message-ID: <20090928151628.62955233@lxorguk.ukuu.org.uk>
In-Reply-To: <20090928135332.4300.56046.stgit@warthog.procyon.org.uk>
References: <20090928135332.4300.56046.stgit@warthog.procyon.org.uk>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Sep 2009 14:53:32 +0100
David Howells <dhowells@redhat.com> wrote:

> Remove pty_ops_bsd as nothing appears to use it anymore.  It results in the
> following warning:
> 
> 	drivers/char/pty.c:344: warning: unused variable `pty_ops_bsd'
> 
> if CONFIG_LEGACY_PTYS=y.
> 
> Also remove pty_bsd_ioctl() as that's only referred to by pty_ops_bsd.
> 
> Possibly legacy_pty_init() should be passing this to tty_set_operations()
> rather than pty_ops.

It should indeed, otherwise the BSD pty locking ioctl fails.
