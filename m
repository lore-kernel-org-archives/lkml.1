Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498AbXDUQ7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbXDUQ7c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 12:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbXDUQ7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 12:59:32 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35640 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbXDUQ7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 12:59:31 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, serue@us.ibm.com,
       viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: Re: [patch 7/8] allow unprivileged mounts
References: <20070420102532.385211890@szeredi.hu>
	<20070420102652.075606533@szeredi.hu>
	<20070421005513.e230aa88.akpm@linux-foundation.org>
	<m1bqhhked1.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.61.0704211743100.9989@yvahk01.tjqt.qr>
Date: Sat, 21 Apr 2007 10:57:10 -0600
In-Reply-To: <Pine.LNX.4.61.0704211743100.9989@yvahk01.tjqt.qr> (Jan
	Engelhardt's message of "Sat, 21 Apr 2007 17:43:28 +0200 (MEST)")
Message-ID: <m1zm51is2h.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh@linux01.gwdg.de> writes:

> On Apr 21 2007 08:10, Eric W. Biederman wrote:
>>>
>>>> Define a new fs flag FS_SAFE, which denotes, that unprivileged
>>>> mounting of this filesystem may not constitute a security problem.
>>>> 
>>>> Since most filesystems haven't been designed with unprivileged
>>>> mounting in mind, a thorough audit is needed before setting this flag.
>>>
>>> Practically speaking, is there any realistic likelihood that any filesystem
>>> apart from FUSE will ever use this?
>>
>>Also potentially some of the kernel virtual filesystems.  /proc should
>>be safe already.  If you don't have any kind of backing store this problem
>>gets easier.
>
> tmpfs!

tmpfs is a possible problem because it can consume lots of ram/swap.  Which
is why it has limits on the amount of space it can consume.  Those are set as
mount options as I recall.  Which means that we would need to do something
different with respect to limits before tmpfs could become safe for
an untrusted user to mount.

Still it's close.


Eric
