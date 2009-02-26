Return-Path: <linux-kernel-owner+w=401wt.eu-S1757486AbZBZQbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486AbZBZQbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 11:31:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbZBZQbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 11:31:38 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:33009 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283AbZBZQbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 11:31:37 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 26 Feb 2009 08:31:34 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Tony Battersby <tonyb@cybernetics.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] [-mm] epoll: clean up ep_modify
In-Reply-To: <49A42E58.50805@cybernetics.com>
Message-ID: <alpine.DEB.2.00.0902260830380.31638@alien.or.mcafeemobile.com>
References: <49A42E58.50805@cybernetics.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Feb 2009, Tony Battersby wrote:

> ep_modify() doesn't need to set event.data from within the ep->lock
> spinlock as the comment suggests.  The only place event.data is used
> is ep_send_events_proc(), and this is protected by ep->mtx instead
> of ep->lock.  Also update the comment for mutex_lock() at the top
> of ep_scan_ready_list(), which mentions epoll_ctl(EPOLL_CTL_DEL)
> but not epoll_ctl(EPOLL_CTL_MOD).
> 
> ep_modify() can also use spin_lock_irq() instead of
> spin_lock_irqsave().

Pre-mtx stuff.

Acked-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


