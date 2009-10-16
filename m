Return-Path: <linux-kernel-owner+w=401wt.eu-S1762356AbZJPPpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762356AbZJPPpQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 11:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761200AbZJPPpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 11:45:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760602AbZJPPpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 11:45:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1255706463.15182.84.camel@dhcp231-106.rdu.redhat.com>
References: <1255706463.15182.84.camel@dhcp231-106.rdu.redhat.com> <7e0fb38c0910160801o50346a5cm763d79cab98272a5@mail.gmail.com> <1255516134-4838-1-git-send-email-graff.yang@gmail.com> <18475.1255529305@redhat.com> <6207.1255706090@redhat.com>
To: Eric Paris <eparis@redhat.com>
Cc: dhowells@redhat.com, graff.yang@gmail.com, linux-kernel@vger.kernel.org,
       gyang@blackfin.uclinux.org, akpm@linux-foundation.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Graff Yang <graf.yang@analog.com>,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] mm/nommu.c: Fix improperly call of security API in mmap
Date: Fri, 16 Oct 2009 16:43:10 +0100
Message-ID: <23382.1255707790@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris <eparis@redhat.com> wrote:

> That would still call cap_file_mmap() and wouldn't solve your problem.

Hmmm...  I guess I don't see the problem occur because I always run the
programs as root.

I would guess that cap_file_mmap() and selinux_file_mmap() are, perhaps, too
strict.  The hint shouldn't be rejected unless MAP_FIXED is also set, surely,
but should rather be revised upwards.

Certainly, addr==NULL and !MAP_FIXED is a reasonable case to permit, even in
tightly secured MMU and SELinux mode...  After all, the manual page says:

	If addr is NULL, then the kernel chooses the address at which to create
	the mapping; this is the most portable method of creating  a  new  map-
	ping.

David
