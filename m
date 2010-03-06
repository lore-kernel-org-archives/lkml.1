Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab0CFAYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 19:24:42 -0500
Received: from tango.0pointer.de ([85.214.72.216]:51424 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab0CFAYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 19:24:41 -0500
Date: Sat, 6 Mar 2010 01:24:14 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Roland McGrath <roland@redhat.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Oleg Nesterov <oleg@redhat.com>,
       linux-kernel@vger.kernel.org, Americo Wang <xiyou.wangcong@gmail.com>,
       James Morris <jmorris@namei.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Kyle McMartin <kyle@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>
Subject: Re: [PATCH] exit: PR_SET_ANCHOR for marking processes as reapers
 for  	child processes
Message-ID: <20100306002414.GJ28657@tango.0pointer.de>
References: <20100202120457.GA19605@omega>
 <20100304140822.GA458@redhat.com>
 <20100304221434.17567187@magilla.sf.frob.com>
 <ac3eb2511003051051r50468752o607a8a0309d5ce2e@mail.gmail.com>
 <20100305191816.5EC8ACC@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100305191816.5EC8ACC@magilla.sf.frob.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05.03.10 11:18, Roland McGrath (roland@redhat.com) wrote:

> 
> > Oh, no. Actually getting the SIGCHILD is the needed feature here. A
> > process who sets the ANCHOR flag is surely expected to handle these
> > signals. It's all about a user "init-like" process" that can do
> > similar things for a logged-in user what /sbin/init can to for the
> > system. So, it's all about 1.), and 3.) is a nice side-effect, but not
> > the motivation to do this.
> 
> Please explain this more explicitly.  What the actual init does with
> miscellaneous reparented processes is just reap them and ignore their
> status.  What do you intend an "anchor" process to do other than that?

It could use the grandchildren's SIGCHLDs for various task management
issues: i.e. watching double-forking daemons, catch SIGSEGVS so that you
can crosslink that service state to systems like abrt. Or even just that
you can implement a safe restarting logic: i.e. so that we can easily
wait that a process and its children are fully dead before we restart
the service.

Lennart

-- 
Lennart Poettering                        Red Hat, Inc.
lennart [at] poettering [dot] net
http://0pointer.net/lennart/           GnuPG 0x1A015CC4
