Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbZLHOT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbZLHOT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 09:19:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755470AbZLHOT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 09:19:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755168AbZLHOT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 09:19:56 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4B1E568A.4020005@analog.com>
References: <4B1E568A.4020005@analog.com> <1259128503-28276-1-git-send-email-vapier@gentoo.org> <7253.1260269873@redhat.com>
To: Jie Zhang <jie.zhang@analog.com>
Cc: dhowells@redhat.com, Mike Frysinger <vapier@gentoo.org>,
       uclinux-dev@uclinux.org, David McCullough <davidm@snapgear.com>,
       Greg Ungerer <gerg@uclinux.org>, Paul Mundt <lethal@linux-sh.org>,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] NOMMU: use copy_*_user_page() in access_process_vm()
Date: Tue, 08 Dec 2009 14:19:27 +0000
Message-ID: <9984.1260281967@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jie Zhang <jie.zhang@analog.com> wrote:

> I agree on using 0 instead of NULL. But for !MMU, I think, vaddr is always as
> same as addr. So we don't need to pass it?

FRV flushes the vaddr because in MMU mode the cache flush instructions take
virtual addresses, so if we pass addr as vaddr, I can use the same cache flush
code for both modes.  I suspect it makes little difference to the amount of
code if we pass that rather than 0, as the value is already computed, and
either way, it's going to take one instruction to set up the argument.

Note that Blackfin assumes that it may use the dst address for flushing - an
assumption that isn't valid in MMU mode with a VIVT cache (which I presume
Blackfin isn't, but other CPUs are).

David
