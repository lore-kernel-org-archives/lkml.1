Return-Path: <linux-kernel-owner+w=401wt.eu-S1755683AbXJ2NA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbXJ2NA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 09:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbXJ2NAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 09:00:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbXJ2NAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 09:00:49 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071027141957.GY30533@stusta.de>
References: <20071027141957.GY30533@stusta.de>
To: Adrian Bunk <bunk@kernel.org>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] fs/afs/vlocation.c: fix off-by-one
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Mon, 29 Oct 2007 13:00:26 +0000
Message-ID: <3357.1193662826@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> wrote:

> This patch fixes an off-by-one error spotted by the Coverity checker.

NAK.

Why do you assume it's a NUL-terminated string?  It's not.  It's a fixed
length character array that gets padded out with NULs.

Look 9 lines further down in the file from the change you made.  You'll notice
it is using memcmp() not strcmp().

David
