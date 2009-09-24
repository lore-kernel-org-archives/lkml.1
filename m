Return-Path: <linux-kernel-owner+w=401wt.eu-S1752230AbZIXMaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbZIXMaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 08:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbZIXMah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 08:30:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196AbZIXMah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 08:30:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1253792279-30623-1-git-send-email-graff.yang@gmail.com>
References: <1253792279-30623-1-git-send-email-graff.yang@gmail.com>
To: graff.yang@gmail.com
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, uclinux-dist-devel@blackfin.uclinux.org,
       graf.yang@analog.com
Subject: Re: [PATCH] mm/nommu.c: fix mmap failed due to the vm_region codes
Date: Thu, 24 Sep 2009 13:29:46 +0100
Message-ID: <14655.1253795386@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<graff.yang@gmail.com> wrote:

> Due to the new vm_region codes, mmap will failed if it is MAP_PRIVATE,
> or the get_unmapped_area() not do actual things.

Hmmm...  Seems one of my debugging patches had a work around for this - all it
did was #ifdef-out the first if-statement in do_mmap_private().  That, however,
prevents XIP.

Sadly, your patch doesn't completely fix the problem either.  The BUG in
add_nommu_region() barks.

Let me poke at it some more.

David
