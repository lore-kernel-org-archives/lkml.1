Return-Path: <linux-kernel-owner+w=401wt.eu-S1764907AbXE2MoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764907AbXE2MoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 08:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbXE2MoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 08:44:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbXE2MoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 08:44:05 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070527161252.GA12804@fieldses.org>
References: <20070527161252.GA12804@fieldses.org> <20070527022502.GB10867@fieldses.org> <20070526022342.GA20905@fieldses.org> <20070524165554.22292.38887.stgit@warthog.cambridge.redhat.com> <7436.1180223730@redhat.com> <18750.1180255870@redhat.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] AFS: Implement file locking
X-Mailer: MH-E 8.0; nmh 1.2-20070115cvs; GNU Emacs 22.0.50
Date: Tue, 29 May 2007 13:43:29 +0100
Message-ID: <11388.1180442609@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields <bfields@fieldses.org> wrote:

> > At the moment, yes.  Don't the POSIX and flock lock-handling routines in the
> > kernel normally do that anyway?
> 
> No, they'd upgrade in that case.

I just checked.  The OpenAFS server supports neither lock upgrading nor lock
downgrading.  Attempts to do either incur an abort with code 0x02f6df0a
(which I believe to be equivalent to EAGAIN).

This means that I can't practically support lock upgrading.  Lock downgrading
I can emulate by handing apparent readlocks to local processes whilst holding
a writelock on the server.

David
