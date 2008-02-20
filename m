Return-Path: <linux-kernel-owner+w=401wt.eu-S935456AbYBTQgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935456AbYBTQgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933500AbYBTQT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:19:56 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:60407 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933486AbYBTQTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:19:54 -0500
Date: Wed, 20 Feb 2008 19:18:23 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Valdis.Kletnieks@vt.edu
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, roland@redhat.com,
       linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: tty && pid problems
Message-ID: <20080220161823.GB146@tv-sign.ru>
References: <20080215180204.GA4359@tv-sign.ru> <20080215193756.9e5b8205.akpm@linux-foundation.org> <20080216140212.GA1421@tv-sign.ru> <20080217231019.GA83@tv-sign.ru> <m1skzq9a59.fsf@ebiederm.dsl.xmission.com> <23492.1203464394@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23492.1203464394@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Change the subject, cc Alan)

On 02/19, Valdis.Kletnieks@vt.edu wrote:
>
> On Sun, 17 Feb 2008 21:11:14 MST, Eric W. Biederman said:
> > Oleg Nesterov <oleg@tv-sign.ru> writes:
> > > On 02/16, Oleg Nesterov wrote:
> > >> On 02/15, Andrew Morton wrote:
> > >> > : BUG: unable to handle kernel paging request at 0000000000200200
> 
> > >> > : Call Trace:
> > >> > :  [<ffffffff80237727>] ? release_task+0x152/0x2e5
> > >> > :  [<ffffffff80237f81>] ? do_wait+0x6c7/0xa1c
> > >> > :  [<ffffffff8022f4cc>] ? default_wake_function+0x0/0xe
> > >> > :  [<ffffffff8023e670>] ? sys_rt_sigaction+0x7a/0x98
> > >> > :  [<ffffffff80238360>] ? sys_wait4+0x8a/0xa1
> > >> > :  [<ffffffff8020be4b>] ? system_call_after_swapgs+0x7b/0x80
> 
> > Thanks.  Looks like we need to grab a lock there.
> > At a quick skim I think we need the tty lock.
> 
> *ping* - Any further activity on this one?  I got bit by it as well on
> the very first attempted boot of 25-rc2-mm1, the instant it tried to leave
> single-user and go multi-user.

Valdis, any chance you can try the
	"[PATCH] (for -mm only) put_pid: make sure we don't free the live pid"
I sent? just to make sure we don't have other problems here.

Oleg.

