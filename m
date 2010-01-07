Return-Path: <linux-kernel-owner+w=401wt.eu-S1753069Ab0AGVfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab0AGVfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 16:35:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714Ab0AGVfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 16:35:10 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53659 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab0AGVfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 16:35:05 -0500
Date: Thu, 7 Jan 2010 22:35:04 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Staubach <staubach@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: Re: [GIT PULL] Please pull NFS client bugfixes....
Message-ID: <20100107213504.GC16076@basil.fritz.box>
References: <1262896174.2659.3.camel@localhost> <87zl4pmxzp.fsf@basil.nowhere.org> <4B4650CA.4010703@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B4650CA.4010703@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 04:23:22PM -0500, Peter Staubach wrote:
> It seems to me that NFS must do some sort of validation at
> this point.  This is one of the last points where the NFS
> client can do validation for mmap'd files.

Typically there is a open directly before it. open seems
like a much more natural point to synchronize than mmap.

Also so far nobody could point me to a standard text or similar
who said mmap needs synchronization, just some vague beliefs.

And the fact is right now with the current Linux VFS and
NFS locking mmap can't do it reliably.

> I think that the file system must have a way to do validation
> and page invalidation during mmap.  Perhaps we can reorder
> things or add another entry point which is invoked after the
> page mapping is set up which would give the file system to
> check to ensure that the page cache is filled with valid data.

If someone has a better patch feel free to post it, but ignoring
the problem like it has been done so far doesn't fly.

I know that my patch works for me at least.

-Andi

