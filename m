Return-Path: <linux-kernel-owner+w=401wt.eu-S1423346AbXDYRsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423346AbXDYRsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 13:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423343AbXDYRsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 13:48:16 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38877 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423334AbXDYRsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 13:48:14 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Miklos Szeredi <miklos@szeredi.hu>,
       akpm@linux-foundation.org, viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, linux-security-module@vger.kernel.org
Subject: Re: [patch] unprivileged mounts update
References: <E1HgcBv-00049Z-00@dorka.pomaz.szeredi.hu>
	<E1HgjG0-0005CN-00@dorka.pomaz.szeredi.hu>
	<462F87EA.1000002@zytor.com>
	<20070425172012.GA20336@sergelap.austin.ibm.com>
Date: Wed, 25 Apr 2007 11:46:15 -0600
In-Reply-To: <20070425172012.GA20336@sergelap.austin.ibm.com> (Serge
	E. Hallyn's message of "Wed, 25 Apr 2007 12:20:12 -0500")
Message-ID: <m1k5w0s5y0.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:

> Quoting H. Peter Anvin (hpa@zytor.com):
>> Miklos Szeredi wrote:
>> > 
>> > Andrew, please skip this patch, for now.
>> > 
>> > Serge found a problem with the fsuid approach: setfsuid(nonzero) will
>> > remove filesystem related capabilities.  So even if root is trying to
>> > set the "user=UID" flag on a mount, access to the target (and in case
>> > of bind, the source) is checked with user privileges.
>> > 
>> > Root should be able to set this flag on any mountpoint, _regardless_
>> > of permissions.
>> > 
>> 
>> Right, if you're using fsuid != 0, you're not running as root 
>
> Sure, but what I'm not clear on is why, if I've done a
> prctl(PR_SET_KEEPCAPS, 1) before the setfsuid, I still lose the
> CAP_FS_MASK perms.  I see the special case handling in
> cap_task_post_setuid().  I'm sure there was a reason for it, but
> this is a piece of the capability implementation I don't understand
> right now.

So we drop CAP_CHOWN, CAP_DAC_OVERRIDE, CAP_DAC_READ_SEARCH,
CAP_FOWNER, and CAP_FSETID

Since we are checking CAP_SETUID or CAP_SYS_ADMIN how is that
a problem?

Are there other permission checks that mount is doing that we
care about.


>> (fsuid is
>> the equivalent to euid for the filesystem.)
>
> If it were really the equivalent then I could keep my capabilities :)
> after changing it.

We drop all capabilities after we change the euid.

>> I fail to see how ruid should have *any* impact on mount(2).  That seems
>> to be a design flaw.
>
> May be, but just using fsuid at this point stops me from enabling user
> mounts under /share if /share is chmod 000 (which it is).

I'm dense today.  If we can't work out the details we can always use a flag.
But what is the problem with fsuid?

You are not trying to test this using a non-default security model are you?


Eric
