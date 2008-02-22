Return-Path: <linux-kernel-owner+w=401wt.eu-S936420AbYBVBmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936420AbYBVBmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 20:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760703AbYBVBmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 20:42:14 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:34648 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758001AbYBVBmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 20:42:12 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Valdis.Kletnieks@vt.edu,
       Andrew Morton <akpm@linux-foundation.org>, roland@redhat.com,
       linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: tty && pid problems
References: <20080215180204.GA4359@tv-sign.ru>
	<20080215193756.9e5b8205.akpm@linux-foundation.org>
	<20080216140212.GA1421@tv-sign.ru> <20080217231019.GA83@tv-sign.ru>
	<m1skzq9a59.fsf@ebiederm.dsl.xmission.com>
	<23492.1203464394@turing-police.cc.vt.edu>
	<20080220161823.GB146@tv-sign.ru> <20080220161941.6e9a2e16@core>
Date: Thu, 21 Feb 2008 18:39:21 -0700
In-Reply-To: <20080220161941.6e9a2e16@core> (Alan Cox's message of "Wed, 20
	Feb 2008 16:19:41 +0000")
Message-ID: <m1ejb56a7q.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

>> > *ping* - Any further activity on this one?  I got bit by it as well on
>> > the very first attempted boot of 25-rc2-mm1, the instant it tried to leave
>> > single-user and go multi-user.
>> 
>> Valdis, any chance you can try the
>> 	"[PATCH] (for -mm only) put_pid: make sure we don't free the live pid"
>> I sent? just to make sure we don't have other problems here.
>
> There is some other iffy locking of the pid objects ever since they were
> changed from pid_t to ref counted structs. Whoever did that didn't add
> any locking for it, and the old code knew it was "safe" not to.
>
> I've added locks in my test tree and now I've finally got -mm to build
> will do some testing then push more stuff upstream

Thanks.  At the tty layer that was probably me.
Most of the instances already appear to be nested in some other kind of
locking, but that doesn't make no additional locking correct or ensure
that it will give a uniform result.

Eric

