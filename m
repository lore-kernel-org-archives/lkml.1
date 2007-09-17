Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbXIQP2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbXIQP2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 11:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbXIQP15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 11:27:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35394 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754509AbXIQP15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 11:27:57 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1577.1189713412@redhat.com>
References: <1577.1189713412@redhat.com>
To: viro@ftp.linux.org.uk, hch@infradead.org, torvalds@osdl.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: Credentials test patch
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Mon, 17 Sep 2007 16:27:43 +0100
Message-ID: <19966.1190042863@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

>  (1) Permit one process to change another process's cred struct.  This means
>      that a process wishing to read its own creds must use RCU read to do so,
>      and a lock must be held when replacing the cred struct.

Having thought about this some more, I've realised that this also doesn't work
if when one thread tries to alter another thread's creds that other thread's
cred struct is currently overridden.

>  (2) Explicitly update the cred struct on entry to syscalls that might want to
>      use it.

So, I think this has to be the best way to do things.  It's the cleanest,
certainly and probably has the lowest overhead overall.

This also means that I don't need that horrible __current_cred() function that
Linus so objects to (I do too).

David
