Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbXDYBGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbXDYBGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 21:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754677AbXDYBGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 21:06:47 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:57141 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673AbXDYBGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 21:06:46 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Karel Zak <kzak@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       serue@us.ibm.com, viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: Re: [patch 0/8]  mount ownership and unprivileged mount syscall (v4)
References: <20070420102532.385211890@szeredi.hu>
	<20070425000414.GH14086@petra.dvoda.cz>
Date: Tue, 24 Apr 2007 19:04:36 -0600
In-Reply-To: <20070425000414.GH14086@petra.dvoda.cz> (Karel Zak's message of
	"Wed, 25 Apr 2007 02:04:14 +0200")
Message-ID: <m1647ltgbf.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Karel Zak <kzak@redhat.com> writes:

> On Fri, Apr 20, 2007 at 12:25:32PM +0200, Miklos Szeredi wrote:
>> The following extra security measures are taken for unprivileged
>> mounts:
>> 
>>  - usermounts are limited by a sysctl tunable
>>  - force "nosuid,nodev" mount options on the created mount
>
>  The original userspace "user=" solution also implies the "noexec"
>  option by default (you can override the default by "exec" option).
>  
>  It means the kernel based solution is not fully compatible ;-(

Why noexec?  Either it was a silly or arbitrary decision, or
our kernel design may be incomplete.

Now I can see not wanting to support executables if you are locking
down a system.  The classic don't execute a program from a CD just because
the CD was stuck in the drive problem.

So I can see how executing code from an untrusted source could prevent
exploitation of other problems, and we certainly don't want to do it
automatically.

Eric
