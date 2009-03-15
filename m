Return-Path: <linux-kernel-owner+w=401wt.eu-S1757259AbZCOByv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259AbZCOByv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 21:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbZCOByn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 21:54:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358AbZCOBym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 21:54:42 -0400
Date: Sat, 14 Mar 2009 21:54:38 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] deadlock when swapping to FAT
In-Reply-To: <87zlfqohfn.fsf@devron.myhome.or.jp>
Message-ID: <Pine.LNX.4.64.0903142153330.23664@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0903120819010.26206@hs20-bc2-1.build.redhat.com>
 <87zlfqohfn.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 13 Mar 2009, OGAWA Hirofumi wrote:

> Mikulas Patocka <mpatocka@redhat.com> writes:
> 
> > swapon will deadlock when an attempt to swap to a file on FAT filesystem 
> > is made. swapon holds i_mutex and FAT bmap is attempting to take it again.
> >
> > This bug was introduced somewhere between 2.6.27 and 2.6.28.
> >
> > No other filesystem is taking i_mutex in bmap, so I removed it as well.
> >
> > Note that there are many other cases where bmap can race with truncate in 
> > almost all the filesystems. They don't impose an immediate threat because 
> > bmap can be only called by root. These problems should be solved in a 
> > generic way, not in individual filesystems.
> 
> Thanks. This was fixed recently with a bit different way.
> -- 
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Note that the same race condition is happening in all the other 
filesystems. Maybe move that i_alloc_sem up to ->bmap method caller?

Mikulas
