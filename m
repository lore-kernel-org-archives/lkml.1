Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbZLBOqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbZLBOqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 09:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbZLBOqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 09:46:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791AbZLBOqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 09:46:17 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1259128503-28276-1-git-send-email-vapier@gentoo.org>
References: <1259128503-28276-1-git-send-email-vapier@gentoo.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: dhowells@redhat.com, uclinux-dev@uclinux.org,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Jie Zhang <jie.zhang@analog.com>
Subject: Re: [PATCH] NOMMU: use copy_*_user_page() in access_process_vm()
Date: Wed, 02 Dec 2009 14:45:24 +0000
Message-ID: <16399.1259765124@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger <vapier@gentoo.org> wrote:

> The mmu code uses the copy_*_user_page() variants in access_process_vm()
> rather than copy_*_user() as the former includes an icache flush.  This is
> important when doing things like setting software breakpoints with gdb.
> So switch the nommu code over to do the same.

Note that we may only really want to do an icache flush if the target region
is mapped executable somewhere.  On the other hand, for debugging stuff on an
embedded board, it probably doesn't matter.

David
