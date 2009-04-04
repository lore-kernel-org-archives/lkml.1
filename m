Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbZDDQvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbZDDQvI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 12:51:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750943AbZDDQuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 12:50:55 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:38486 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbZDDQuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 12:50:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fe4HJJou1FapSUQ+qRyjz+mbJEf4cgDUz50K/NoeLqo0pQyaEFUuKgmFg12onuHA2q
         VE77oBIDMdP+thD44FnUMYpZ8pC6goGxudHL0Ru0RH3hUDMes1D8cBJTwt6Phg9mVXEo
         iFHWZez5jENdf7t650t+miBrDz3+/roT04Az4=
Date: Sun, 5 Apr 2009 00:51:44 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Am??rico Wang <xiyou.wangcong@gmail.com>,
       Miklos Szeredi <miklos@szeredi.hu>,
       user-mode-linux-devel@lists.sourceforge.net, jdike@addtoit.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: do_execve() needs const qualifiers (was Re: [patch 3/3] uml:
	fix warnings in kernel_execve)
Message-ID: <20090404165144.GB17018@hack>
References: <E1LoMQ2-0007bB-By@pomaz-ex.szeredi.hu> <E1LoMTw-0007d2-AI@pomaz-ex.szeredi.hu> <20090401161114.GF3848@hack> <20090401162122.GE28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401162122.GE28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 05:21:22PM +0100, Al Viro wrote:
>On Thu, Apr 02, 2009 at 12:11:14AM +0800, Am??rico Wang wrote:
>> On Mon, Mar 30, 2009 at 08:45:12PM +0200, Miklos Szeredi wrote:
>> >From: Miklos Szeredi <mszeredi@suse.cz>
>> >
>> >Fix the following warnings:
>> >
>> >arch/um/kernel/syscall.c: In function 'kernel_execve':
>> >arch/um/kernel/syscall.c:130: warning: passing argument 1 of 'um_execve' discards qualifiers from pointer target type
>> >arch/um/kernel/syscall.c:130: warning: passing argument 2 of 'um_execve' discards qualifiers from pointer target type
>> >arch/um/kernel/syscall.c:130: warning: passing argument 3 of 'um_execve' discards qualifiers from pointer target type
>> >
>> >Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
>> >---
>> > arch/um/kernel/syscall.c |    3 ++-
>> > 1 file changed, 2 insertions(+), 1 deletion(-)
>> >
>> >Index: linux-2.6/arch/um/kernel/syscall.c
>> >===================================================================
>> >--- linux-2.6.orig/arch/um/kernel/syscall.c	2009-03-30 20:25:17.000000000 +0200
>> >+++ linux-2.6/arch/um/kernel/syscall.c	2009-03-30 20:36:20.000000000 +0200
>> >@@ -127,7 +127,8 @@ int kernel_execve(const char *filename,
>> > 
>> > 	fs = get_fs();
>> > 	set_fs(KERNEL_DS);
>> >-	ret = um_execve(filename, argv, envp);
>> >+	ret = um_execve((char *)filename, (char __user *__user *)argv,
>> >+			(char __user *__user *) envp);
>> 
>> Well... I found this many days ago and I did a similar fix.
>> 
>> However, I think this doesn't fix the real problem. The real problem
>> is do_execve() doesn't have the correct const qualifiers, I am queueing
>> a huge patch to fix all the 'const' issues from do_execve() and more,
>> but I don't if Al would like it or not.
>
>I don't know...  The thing is, it'll trail down into bprm->filename /
>bprm->interp and the things get very ugly very fast from that point.

Yes, I agree, my queued patch is huge. 8-)
But it is still worthy to fix, right?
 
