Return-Path: <linux-kernel-owner+w=401wt.eu-S1757886AbYDBOpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886AbYDBOpA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 10:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755878AbYDBOow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 10:44:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754734AbYDBOow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 10:44:52 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <8bd0f97a0804011434r4869fbe8t89ade12c04c97f2@mail.gmail.com>
References: <8bd0f97a0804011434r4869fbe8t89ade12c04c97f2@mail.gmail.com>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Cc: dhowells@redhat.com, "Greg Ungerer" <gerg@snapgear.com>,
       "David McCullough" <David_Mccullough@securecomputing.com>,
       LKML <linux-kernel@vger.kernel.org>, "Bryan Wu" <Bryan.Wu@analog.com>,
       "Bernd Schmidt" <bernds_cb1@t-online.de>,
       "Robin Getz" <rgetz@blackfin.uclinux.org>
Subject: Re: nommu: handling anonymous mmap clearing in userspace rather than kernel
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 02 Apr 2008 15:20:14 +0100
Message-ID: <5516.1207146014@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger <vapier.adi@gmail.com> wrote:

> a workaround: introduce a new no-mmu-only mmap flag MAP_UNINITIALIZE
> to signal to the kernel that it should skip the memset().  this way,
> userspace malloc() can do mmap(MAP_ANONYMOUS|MAP_UNINITIALIZE) to get
> large chunks of memory without affecting any other anonymous mmap()
> call.

I think that's reasonable for NOMMU.  It's not like the process accessing the
uninitialised memory is prevented from accessing anything it wants to anyway.

I would vote that the memset() should only be skipped if requested as there
may be programs that call mmap(MAP_ANONYMOUS) expecting the memory they're
given to be zeroed out.

David


