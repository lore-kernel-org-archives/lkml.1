Return-Path: <linux-kernel-owner+w=401wt.eu-S1756967AbZCLQFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967AbZCLQFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 12:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbZCLQFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 12:05:23 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:57729 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbZCLQFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 12:05:22 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] deadlock when swapping to FAT
References: <Pine.LNX.4.64.0903120819010.26206@hs20-bc2-1.build.redhat.com>
Date: Fri, 13 Mar 2009 01:05:16 +0900
In-Reply-To: <Pine.LNX.4.64.0903120819010.26206@hs20-bc2-1.build.redhat.com>
	(Mikulas Patocka's message of "Thu, 12 Mar 2009 08:30:05 -0400 (EDT)")
Message-ID: <87zlfqohfn.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikulas Patocka <mpatocka@redhat.com> writes:

> swapon will deadlock when an attempt to swap to a file on FAT filesystem 
> is made. swapon holds i_mutex and FAT bmap is attempting to take it again.
>
> This bug was introduced somewhere between 2.6.27 and 2.6.28.
>
> No other filesystem is taking i_mutex in bmap, so I removed it as well.
>
> Note that there are many other cases where bmap can race with truncate in 
> almost all the filesystems. They don't impose an immediate threat because 
> bmap can be only called by root. These problems should be solved in a 
> generic way, not in individual filesystems.

Thanks. This was fixed recently with a bit different way.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
