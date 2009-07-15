Return-Path: <linux-kernel-owner+w=401wt.eu-S1754354AbZGOM1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354AbZGOM1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 08:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbZGOM1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 08:27:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54673 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753702AbZGOM1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 08:27:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <8bd0f97a0907150455l59a86540l655604579ab70b4f@mail.gmail.com>
References: <8bd0f97a0907150455l59a86540l655604579ab70b4f@mail.gmail.com> <1247591665-12000-1-git-send-email-vapier@gentoo.org> <20090714161416.GA19147@cmpxchg.org> <6206.1247592126@redhat.com> <4A5CFFD8.7020106@t-online.de> <12377.1247654255@redhat.com> <8bd0f97a0907150412h234cf4d6l439d92d832055373@mail.gmail.com> <2898.1247658300@redhat.com> 
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: dhowells@redhat.com, Bernd Schmidt <bernds_cb1@t-online.de>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [Uclinux-dist-devel] [PATCH v2] NOMMU: add support for Memory Protection Units (MPU)
Date: Wed, 15 Jul 2009 13:25:42 +0100
Message-ID: <3751.1247660742@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger <vapier.adi@gmail.com> wrote:

> yes, you can see page_rwx_mask in our mmu.h's mm_context_t.  this is
> what the protect_page/update_protections operate on.  we have a global
> current_rwx_mask that gets updated during context changes and the CPLB
> miss handler uses that to keep things simple.

Interesting.

Since FRV does not really allow separate execute permissions (it has a very
few separate static I and D protection/mapping registers and a shared TLB), I
could do it with just pairs of bits.

Also, how do you deal with mappable devices that lie outside of RAM?  I'm
guessing from the code that you don't cover those with the bitmap, but rather
just grant userspace RW access.

David
