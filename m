Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab0CFAQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 19:16:47 -0500
Received: from tango.0pointer.de ([85.214.72.216]:35919 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab0CFAQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 19:16:45 -0500
Date: Sat, 6 Mar 2010 01:16:16 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Americo Wang <xiyou.wangcong@gmail.com>,
       James Morris <jmorris@namei.org>, Kay Sievers <kay.sievers@vrfy.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Kyle McMartin <kyle@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] exit: PR_SET_ANCHOR for marking processes as reapers
 	for child processes
Message-ID: <20100306001616.GH28657@tango.0pointer.de>
References: <20100202120457.GA19605@omega>
 <20100304140822.GA458@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100304140822.GA458@redhat.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04.03.10 15:08, Oleg Nesterov (oleg@redhat.com) wrote:

> Should we clear ->child_anchor flags when the "sub-init" execs? Or,
> at least, when the task changes its credentials? Probably not, but
> dunno.

Since this flag is only useful for a very well defined type of processes
(i.e. session managers, supervising daemons, init systems) it might make
sense to reset it automatically when privs are dropped or we exec
something. After all, I don't see how we'd gain any useful functionality
when we allow this flag to continue to be set. However we would
certainly be on the safer side when we reset it, because that way it can
never leak it to processes that are differently privileged or do not
expect it.

So, for the sake of being on the safe side, I think we should reset the
flag on exec()/setuid().

> It is a bit strange that PR_SET_ANCHOR acts per-thread, not per
> process.

Yes, I agree, this should be per-process indeed.

Lennart

-- 
Lennart Poettering                        Red Hat, Inc.
lennart [at] poettering [dot] net
http://0pointer.net/lennart/           GnuPG 0x1A015CC4
