Return-Path: <linux-kernel-owner+w=401wt.eu-S934661AbXK3OBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934661AbXK3OBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 09:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754126AbXK3OBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 09:01:30 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbXK3OB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 09:01:29 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1196430400.13978.26.camel@pmac.infradead.org>
References: <1196430400.13978.26.camel@pmac.infradead.org> <20071129225219.21536.58653.stgit@warthog.procyon.org.uk> <20071129225301.21536.91506.stgit@warthog.procyon.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: dhowells@redhat.com, tharbaugh@lnxi.com, akpm@linux-foundation.org,
       linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] MN10300: Fix MTD JEDEC probe so that the ASB2303 bootprom can be detected [2.6.24-rc3-mm2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Fri, 30 Nov 2007 14:01:16 +0000
Message-ID: <28258.1196431276@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse <dwmw2@infradead.org> wrote:

> I don't like this -- it shouldn't be necessary.

Actually, I think you're right.  I think the problem is that:

        if (uaddr != MTD_UADDR_NOT_SUPPORTED ) {
                /* ASSERT("The unlock addresses for non-8-bit mode
                   are bollocks. We don't really need an array."); */
                uaddr = finfo->uaddr[0];
        }

Should be:

        if (uaddr == MTD_UADDR_NOT_SUPPORTED ) {
                /* ASSERT("The unlock addresses for non-8-bit mode
                   are bollocks. We don't really need an array."); */
                uaddr = finfo->uaddr[0];
        }

Otherwise the finfo->uaddr[] table is useless because only the first row will
be used, except for unsupported configurations where uaddr will be set to
MTD_UADDR_NOT_SUPPORTED.

With the ASB2303 bootprom I need to use the second row because it's in the x16
configuration, *not* the x8.

David
