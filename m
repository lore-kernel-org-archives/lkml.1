Return-Path: <linux-kernel-owner+w=401wt.eu-S1753881AbYEJJHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbYEJJHi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 05:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbYEJJH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 05:07:28 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:14648 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbYEJJH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 05:07:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=g/Jblz/pO5p1auuIvTuZ/cu+a5kMCbQJXqocuBIdQiEx3Gl49HyBn/YXh+a1AEpdQ/0cuqU6upUej8tt2qgZj4ayPzzWb0UvtWb1rI6xeHxUDsFFslWC2wf5wIc1pmCdH1R45zT1tC49F0xmBdweEXTcZBFXw3JZbmL2ZpvGUoQ=
Message-ID: <e2e108260805100207l13b67706h871f5f1c550e58b3@mail.gmail.com>
Date: Sat, 10 May 2008 11:07:25 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: [ANNOUNCE] kmemcheck v7
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Daniel Walker" <dwalker@mvista.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>, "Josh Aune" <luken@omner.org>,
       "Pekka Paalanen" <pq@iki.fi>
In-Reply-To: <47F630AE.7050801@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47F630AE.7050801@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 4, 2008 at 3:44 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> I skipped the public announcements for versions 5 and 6, but here is 7 :)
>
> General description: kmemcheck is a patch to the linux kernel that
> detects use of uninitialized memory. It does this by trapping every
> read and write to memory that was allocated dynamically (e.g. using
> kmalloc()). If a memory address is read that has not previously been
> written to, a message is printed to the kernel log.
>
> Changes since v4 (rough list):
> - SLUB parts were broken-out into its own file to avoid cluttering the main
>  SLUB code.
> - A rather lot of cleanups, including removing #ifdefs from arch code.
> - Some preparation in anticipation of an x86_64 port.
> - Make reporting safer by using a periodic timer to inspect the error queue.
> - Fix hang due to page flags changing too early on free().
> - Fix hang due to kprobes incompatibility.
> - Allow CONFIG_SMP, but limit number of CPUs to 1 at run-time.
> - Add kmemcheck=0|1 boot option.
> - Add /proc/sys/kernel/kmemcheck for run-time enabling/disabling.
>
>
> These patches apply to Linus's v2.6.25-rc8. The latest patchset can also be
> found here: http://folk.uio.no/vegardno/linux/kmemcheck/

(reply to an e-mail of one month ago)

Hello Vegard,

It's a bit late but I finally found out about your announcement of
kmemcheck version 7. Are you familiar with the patch that adds support
to Valgrind for User Mode Linux ? I'm not sure what the best approach
is -- letting the kernel do its own checking like kmemcheck or extend
Valgrind such that it supports UML. Anyway, the techniques applied in
Valgrind may be useful for kmemcheck too, such as the algorithms used
in Valgrind to compress the memory state information.

See also:
http://www.mail-archive.com/user-mode-linux-devel@lists.sourceforge.net/msg05602.html

Bart.
