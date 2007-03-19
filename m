Return-Path: <linux-kernel-owner+w=401wt.eu-S1030384AbXCSRnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030384AbXCSRnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 13:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030395AbXCSRnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 13:43:16 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:39788 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030384AbXCSRnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 13:43:14 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Paul Menage" <menage@google.com>
Cc: "Dave Hansen" <hansendc@us.ibm.com>, containers@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Mel Gorman <MELGOR@ie.ibm.com>, linux-kernel@vger.kernel.org,
       Andy Wihitcroft <apw@shadowen.org>
Subject: Re: [Devel] Re: [RFC][PATCH 2/7] RSS controller core
References: <45ED7DEC.7010403@sw.ru> <45F3F581.9030503@sw.ru>
	<20070311045111.62d3e9f9.akpm@linux-foundation.org>
	<20070312010039.GC21861@MAIL.13thfloor.at>
	<1173724979.11945.103.camel@localhost.localdomain>
	<20070312224129.GC21258@MAIL.13thfloor.at>
	<20070312220439.677b4787.akpm@linux-foundation.org>
	<45F67AC9.4080707@sw.ru>
	<20070313034834.14013bb0.akpm@linux-foundation.org>
	<1173805534.6680.26.camel@localhost.localdomain>
	<6599ad830703181544g52f25820rff1c87e462b8f1d4@mail.gmail.com>
Date: Mon, 19 Mar 2007 11:41:23 -0600
In-Reply-To: <6599ad830703181544g52f25820rff1c87e462b8f1d4@mail.gmail.com>
	(Paul Menage's message of "Sun, 18 Mar 2007 15:44:24 -0700")
Message-ID: <m1ircxxha4.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Paul Menage" <menage@google.com> writes:

> On 3/13/07, Dave Hansen <hansendc@us.ibm.com> wrote:
>> How do we determine what is shared, and goes into the shared zones?
>> Once we've allocated a page, it's too late because we already picked.
>> Do we just assume all page cache is shared?  Base it on filesystem,
>> mount, ...?  Mount seems the most logical to me, that a sysadmin would
>> have to set up a container's fs, anyway, and will likely be doing
>> special things to shared data, anyway (r/o bind mounts :).
>
> I played with an approach where you can bind a dentry to a set of
> memory zones, and any children of that dentry would inherit the
> mempolicy; I was envisaging that most data wouldn't be shared between
> different containers/jobs, and that userspace would set up "shared"
> zones for big shared regions such as /lib, /usr, /bin, and for
> specially-known cases of sharing.

Here is a wacky one.

Suppose there is some NFS server that exports something that most machines
want to mount like company home directories.

Suppose multiple containers mount that NFS server based on local policy.
(If we can allow non-root users to mount filesystems a slightly more trusted
 guest admin certainly will be able to).

The NFS code as current written (unless I am confused) will do
everything in it's power to share the filesystem cache between the
different mounts (including the dentry tree).

How do we handle bit shared areas like that.

Dynamic programming solutions where we discovery the areas of sharing
at runtime seem a lot more general then a priori solutions where you
have to predict what will come next.

If a priori planning and knowledge about sharing is the best we can do
it is the best we can do and we will have to live with the limits that
imposes.  Given the inflexibility in use and setup I'm not yet ready
to concede that this is the best we can do.

Eric
