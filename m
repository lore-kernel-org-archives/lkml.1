Return-Path: <linux-kernel-owner+w=401wt.eu-S1757087AbYCYRiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087AbYCYRiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 13:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbYCYRiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 13:38:16 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:42815 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905AbYCYRiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 13:38:15 -0400
Date: Tue, 25 Mar 2008 20:42:51 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, ebiederm@xmission.com,
       xemul@openvz.org, pavel@ucw.cz, sds@tycho.nsa.gov, roland@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: it is fun to strace /sbin/init
Message-ID: <20080325174251.GA247@tv-sign.ru>
References: <20080323135110.GA294@tv-sign.ru> <20080324152906.dee7b272.akpm@linux-foundation.org> <20080324225611.GA157@tv-sign.ru> <20080324160819.cea2d921.akpm@linux-foundation.org> <87r6dzi0mw.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r6dzi0mw.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25, Andi Kleen wrote:
>
> Andrew Morton <akpm@linux-foundation.org> writes:
> > 
> > Why not just unconditionally enable root's abiltiy to ptrace init?
> 
> It would be fine to allow this unconditionally if there was some mechanism
> to make sure someone else takes over reaping childs while init is ptraced.

I think we can't do this. From my /etc/inittab:

	c1:1235:respawn:/sbin/agetty 38400 tty1 linux

If /sbin/agetty exits, we shouldn't reap it. /sbin/init should notice
the death of login, and respawn the new child.

Thanks to all for replies! I'll re-send this patch as one-liner, without
any boot params or sysctls, and with long CC list.

I hope someone (not me) will make a final authoritative decision ;)

Oleg.

