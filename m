Return-Path: <linux-kernel-owner+w=401wt.eu-S1754402AbYKNQv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402AbYKNQv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 11:51:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbYKNQvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 11:51:21 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45580 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526AbYKNQvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 11:51:20 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081114163428.7b676742@lxorguk.ukuu.org.uk>
References: <20081114163428.7b676742@lxorguk.ukuu.org.uk> <20081114162038.23016.20581.stgit@warthog.procyon.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: dhowells@redhat.com, linux-serial@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix an uninitialised variable warning in the 8250 driver
Date: Fri, 14 Nov 2008 16:51:08 +0000
Message-ID: <26417.1226681468@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> Current versions of gcc that I've tested get this all correct just fine
> for x86 at least.

gcc version 4.1.2 20070925 (Red Hat 4.1.2-33)

> Do check that the BUG_ON() helper for whatever platform you are using
> needs to correctly indicate that its BUG spewing path may not return
> (__attibute((__noreturn__)). I seem to remember some of the architectures
> are broken on that.

x86_64 - which doesn't do that.  It uses asm volatile and an infinite for-loop.

Surely having BUG() retreat through a noreturn function may lose important
state, such as the function that issued the bug as the compiler is under no
requirement to save the return value, and the file/line info may not be
available.

David
