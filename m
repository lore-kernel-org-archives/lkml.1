Return-Path: <linux-kernel-owner+w=401wt.eu-S1753025AbXDUVfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbXDUVfW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 17:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbXDUVfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 17:35:22 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:52035 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbXDUVfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 17:35:21 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, serue@us.ibm.com,
       viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: Re: [patch 7/8] allow unprivileged mounts
References: <20070420102532.385211890@szeredi.hu>
	<20070420102652.075606533@szeredi.hu>
	<20070421005513.e230aa88.akpm@linux-foundation.org>
	<p73d51x4c1w.fsf@bingen.suse.de>
Date: Sat, 21 Apr 2007 15:33:25 -0600
In-Reply-To: <p73d51x4c1w.fsf@bingen.suse.de> (Andi Kleen's message of "22 Apr
	2007 00:06:51 +0200")
Message-ID: <m1d51x2z16.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> Andrew Morton <akpm@linux-foundation.org> writes:
>
>> On Fri, 20 Apr 2007 12:25:39 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:
>> 
>> > Define a new fs flag FS_SAFE, which denotes, that unprivileged
>> > mounting of this filesystem may not constitute a security problem.
>> > 
>> > Since most filesystems haven't been designed with unprivileged
>> > mounting in mind, a thorough audit is needed before setting this flag.
>> 
>> Practically speaking, is there any realistic likelihood that any filesystem
>> apart from FUSE will ever use this?
>
> If it worked for mount --bind for any fs I could see uses of this.  I haven't
> thought
> through the security implications though, so it might not work.

Binding a directory that you have access to in other was is essentially
the same thing as a symlink.  So there are no real security implications
there.  The only problem case I can think of is removal media that you
want to remove but someone has made a bind mount to.  But that is
essentially the same case as opening a file so there are no new
real issues.  Although our diagnostic tools will likely fall behind
for a bit.

We handle the security implications by assigning an owner to all mounts
and only allowing you to add additional mounts on top of a mount you
already own.

If you have the right capabilities you can create a mount owned by
another user.

For a new mount if you don't have the appropriate capabilities nodev
and nosuid will be forced.

Initial super block creation is a lot more delicate so we need the
FS_SAFE flag, to know that the kernel is prepared to deal with the
crazy things that a hostile user space is prepared to do.

Eric
