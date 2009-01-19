Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbZASUTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbZASUTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 15:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbZASUTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 15:19:12 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45873 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbZASUTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 15:19:11 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090120015251.47ea14ff.sfr@canb.auug.org.au>
References: <20090120015251.47ea14ff.sfr@canb.auug.org.au> <20090119211031.934b4c19.sfr@canb.auug.org.au> <11956.1232368171@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: dhowells@redhat.com, James Morris <jmorris@namei.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Hannes Eder" <hannes@hanneseder.net>
Subject: Re: [PATCH] creds: suppress warning in get_cred
Date: Mon, 19 Jan 2009 20:19:00 +0000
Message-ID: <13007.1232396340@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> We do have uintptr_t inside the kernel (it is typedeffed to unsigned
> long) but I used it explicitly because its type is defined to be large
> enough to store any pointer.

I believe that within the kernel, unsigned long is guaranteed to be the same
size as a pointer; so much code will break if this is not true.

> However, I have also verified that using a newer compiler (4.3.2 in my
> case) makes the warning go away as Hannes Eder pointed out when
> mentioning his earlier patch.
> 
> So, your choice.

I don't mind you putting the cast in, but I'd prefer the cast to be via
unsigned long, and I think it should have a comment to indicate why the extra
cast is necessary.

David
