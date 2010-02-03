Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932798Ab0BCRuP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 12:50:15 -0500
Received: from tango.0pointer.de ([85.214.72.216]:37077 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932782Ab0BCRuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 12:50:13 -0500
Date: Wed, 3 Feb 2010 18:49:47 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] exit: PR_SET_ANCHOR for marking processes as reapers
 	for child processes
Message-ID: <20100203174947.GA13943@tango.0pointer.de>
References: <20100202120457.GA19605@omega>
 <20100203153101.GC4177@hack>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100203153101.GC4177@hack>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03.02.10 23:31, Américo Wang (xiyou.wangcong@gmail.com) wrote:

> On Tue, Feb 02, 2010 at 01:04:57PM +0100, Lennart Poettering wrote:
> >
> >This patch adds a simple flag for each process that marks it as an
> >"anchor" process for all its children and grandchildren. If a child of
> >such an anchor dies all its children will not be reparented to init, but
> >instead to this anchor, escaping this anchor process is not possible. A
> >task with this flag set hence acts is little "sub-init".
> 
> This will break the applictions which using 'getppid() == 1' to check
> if its real parent is dead or not...

Usage of the PR_SETANCHOR flag is optional for a process. It won't
break anything unless enabled. So I don't really see a problem here.

Of course, when this flag is used the behaviour is different from what
traditional Unix says what happens with the children of a process when
it dies. But uh, that's the whole point and that's why this flag is
enabled optionally only.

Also, on a side note: code that checks if its parent process died most
likely should rewritten to use PR_DEATHSIG or something like that
anyway, so that it is notified about the parent dying instead of
polling for it manually.

Lennart

-- 
Lennart Poettering                        Red Hat, Inc.
lennart [at] poettering [dot] net
http://0pointer.net/lennart/           GnuPG 0x1A015CC4
