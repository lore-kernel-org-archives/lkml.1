Return-Path: <linux-kernel-owner+w=401wt.eu-S1751547AbZLZG6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbZLZG6b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 01:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbZLZG6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 01:58:30 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:28654 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbZLZG63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 01:58:29 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAIpCNUurR7Ht/2dsb2JhbAC/BJUEhDMEgWU
X-IronPort-AV: E=Sophos;i="4.47,455,1257120000"; 
   d="scan'208";a="456731540"
From: Roland Dreier <rdreier@cisco.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sergei Trofimovich <slyich@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
       Sergei Trofimovich <slyfox@inbox.ru>
Subject: Re: [PATCH] Kbuild: set LC_MESSAGES=C (as LC_CTYPE=C is)
References: <1261761235-9431-1-git-send-email-slyfox@inbox.ru>
	<4B354C70.1060109@zytor.com> <adar5qizg6w.fsf@roland-alpha.cisco.com>
	<4B356730.2080401@zytor.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 25 Dec 2009 22:58:28 -0800
In-Reply-To: <4B356730.2080401@zytor.com> (H. Peter Anvin's message of "Fri,
	25 Dec 2009 17:30:24 -0800")
Message-ID: <adaljgqz0ff.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 26 Dec 2009 06:58:28.0743 (UTC) FILETIME=[D3EDA170:01CA85F8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > > Seems unfortunate to lose localized error messages.  (Although in my
 > > en_US.UTF-8 case, all I get is non-ASCII quote characters)

 > The whole problem is that for some people we lose *all* messages.  This
 > seems all very strange to me at all, but I guess it tweaks some internal
 > detail inside the glibc message library, sigh.

I just meant that people used to be able to get localized error messages
by setting LANG or whatever.  And now they're stuck with ASCII english.

 > > This all started because of the awk invocation in arch/x86/lib.  Maybe
 > > the best idea would be to confine the locale monkeying to that one
 > > place?

 > Except that sed, etc. and even the shell itself have the same class of
 > problems.  Perl doesn't, since it has saner rules for how regular
 > expressions handle ranges.

But pretty much everyone on a modern distro has had a UTF8 locale for
quite a while.  And as far as I know there have been no problems caused
by collation order or anything else.  So this change to always build in
the C locale is just worrying about theoretical problems.

Anyway, not a big deal I guess.

 - R.
