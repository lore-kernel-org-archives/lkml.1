Return-Path: <linux-kernel-owner+w=401wt.eu-S1757264AbZLDUFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbZLDUFB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 15:05:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757227AbZLDUFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 15:05:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757140AbZLDUE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 15:04:59 -0500
Subject: Re: [PATCH] security: do not check mmap_min_addr on nommu systems
From: Eric Paris <eparis@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org, dhowells@redhat.com,
       gyang@blackfin.uclinux.org, john.johansen@canonical.com,
       Mike Frysinger <vapier.adi@gmail.com>, stable@kernel.org
In-Reply-To: <20091203115858.d91b64dc.akpm@linux-foundation.org>
References: <20091203194300.8491.22110.stgit@paris.rdu.redhat.com>
	 <20091203115858.d91b64dc.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Dec 2009 15:01:52 -0500
Message-Id: <1259956912.2722.47.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-03 at 11:58 -0800, Andrew Morton wrote:
> On Thu, 03 Dec 2009 14:43:01 -0500
> Eric Paris <eparis@redhat.com> wrote:
> 
> > nommu systems can do anything with memory they please and so they already
> > win.  mmap_min_addr is the least of their worries.  Currently the
> > mmap_min_addr implementation is problamatic on such systems.  This patch
> > changes the addr_only argument to be a flags which can take the arguments
> > for addr_only or not_addr.  LSMs then need to properly implement these two
> > flags.
> 
> This replaces David's
> nommu-ignore-the-address-parameter-in-the-file_mmap-security-check.patch,
> which missed 2.6.32.
> 
> What are our thoughts wrt backporting this fix in some form into
> 2.6.32.x and earlier?

It would be very simple to do if anyone really wanted it.  Seems the
only people who hit the problem already are happy with their temporary
hack.  If anyone is actually hitting this bug, would actually update to
a stable kernel to get the fix, and would like me to send it that way
let me know and I will.

-Eric

