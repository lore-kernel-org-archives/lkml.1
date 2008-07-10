Return-Path: <linux-kernel-owner+w=401wt.eu-S1760802AbYGJRwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760802AbYGJRwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758731AbYGJRwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:52:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758422AbYGJRwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:52:11 -0400
Message-ID: <48764950.3050405@redhat.com>
Date: Thu, 10 Jul 2008 10:39:28 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Vivek Goyal <vgoyal@redhat.com>, Paul Menage <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Libcg Devel Mailing List <libcg-devel@lists.sourceforge.net>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Peter Zijlstra <pzijlstr@redhat.com>,
       Kazunaga Ikeno <k-ikeno@ak.jp.nec.com>,
       Morton Andrew Morton <akpm@linux-foundation.org>,
       Thomas Graf <tgraf@redhat.com>
Subject: Re: [RFC] How to handle the rules engine for cgroups
References: <20080701191126.GA17376@redhat.com>	<20080703101957.b3856904.kamezawa.hiroyu@jp.fujitsu.com>	<20080703155446.GB9275@redhat.com>	<6599ad830807100223m2453963cwcfbe6eb1ad54d517@mail.gmail.com>	<20080710104852.797fe79c@cuia.bos.redhat.com>	<20080710154035.GA12043@redhat.com>	<48763129.9060903@redhat.com> <20080710132546.264a89cd@cuia.bos.redhat.com>
In-Reply-To: <20080710132546.264a89cd@cuia.bos.redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Rik van Riel wrote:
> One easy way is to have a "migrate on exec" option added to the
> process group code.

That's going to be ugly because the exec functions are signal-safe.
I.e., they can happen at any time.  This would mean that one always has
to set the migration policy before every exec call and that there must
be a way to retrieve the currently selected policy so that it can
potentially be restored.  This policy must be a thread property, not a
process property.

Sticky information like this is IMO always hairy at best.  We had the
same discussion at the time of the sys_indirect discussion.  This new
syscall proposal was the result of sticky information not being suitable
and it could very well be used for the exec syscalls, too.

Again, this is all about failing exec calls of which there can be
arbitrarily many.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkh2SVAACgkQ2ijCOnn/RHSYsgCfeH3tTQLSILTksRTfWPhffY0x
okkAn0fQDRDBkqSboqzfrqlj1zpvA3Hm
=bi0P
-----END PGP SIGNATURE-----
