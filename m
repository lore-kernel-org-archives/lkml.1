Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbYGJWa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbYGJWa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 18:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbYGJWaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 18:30:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115AbYGJWaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 18:30:14 -0400
Message-ID: <48768D53.4000803@redhat.com>
Date: Thu, 10 Jul 2008 15:29:39 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Rik van Riel <riel@redhat.com>, Paul Menage <menage@google.com>,
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
References: <20080701191126.GA17376@redhat.com> <20080703101957.b3856904.kamezawa.hiroyu@jp.fujitsu.com> <20080703155446.GB9275@redhat.com> <6599ad830807100223m2453963cwcfbe6eb1ad54d517@mail.gmail.com> <20080710104852.797fe79c@cuia.bos.redhat.com> <20080710154035.GA12043@redhat.com> <48763129.9060903@redhat.com> <20080710132546.264a89cd@cuia.bos.redhat.com> <48764950.3050405@redhat.com> <20080710184142.GC12043@redhat.com>
In-Reply-To: <20080710184142.GC12043@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Vivek Goyal wrote:
> Before exec, we should be able to determine the
> migration policy related to process/thread (either by reading file or
> something else etc). Set the policy through cgroup file system. If exec
> fails for some reason, we just need to go back to cgroup file system to
> undo the effect of setting migration policy previously set for that thread.

That's what I said.  It would be necessary to get the old state and
reset it if necessary.

As for the interface: I hope nobody honestly thinks that it is doable to
perform a whole bunch of filesystem operations for every exec.

And more: reading a rule file, interpreting the rules to find the best
match, etc is also too expensive.  Every process would have to read the
rule file again.  If this is non-trivial or the rule file is large, the
cost of an exec could easily be overshadowed by the cost of this
preparation.  Unlike the kernel, the userlevel runtime cannot in general
amortize the cost over several exec calls.  Handling all this in the
kernel wouldn't have any of these problems.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkh2jVMACgkQ2ijCOnn/RHQ6JACgx4W0dUh/MK6po23D1ObcnsKA
HOAAn2Qfrh8m5zsdHQoniaoLl12Ut3ZE
=IU/X
-----END PGP SIGNATURE-----
