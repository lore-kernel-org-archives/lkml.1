Return-Path: <linux-kernel-owner+w=401wt.eu-S1753415AbZGJF1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbZGJF1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 01:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750830AbZGJF1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 01:27:34 -0400
Received: from mail-pz0-f175.google.com ([209.85.222.175]:45264 "EHLO
	mail-pz0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbZGJF1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 01:27:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=suZfrHmokTTHk7OM8auWEAb1xfW0mucje8uD7PUiAjNeKGyJ8/R2QpNGODHVijr0fu
         yNkh7zCQbn99GyozFmUoej7vU/fY4iCbnvTeySKvCN9P4WoxRXoA1S9ANZn82mblunNO
         Sby1vbMg4W/lf37b8cu/JJ6paGIQeaKp+RC4o=
Date: Fri, 10 Jul 2009 13:29:38 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>, Changli Gao <xiaosuo@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: PATCH: fd leak if pipe() is called with an invalid address.
Message-ID: <20090710052938.GA6146@cr0.nay.redhat.com>
References: <4A4C6013.9090509@gmail.com> <20090710031854.GC5694@cr0.nay.redhat.com> <alpine.LFD.2.01.0907092029200.3352@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0907092029200.3352@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 09, 2009 at 08:31:03PM -0700, Linus Torvalds wrote:
>
>
>On Fri, 10 Jul 2009, Amerigo Wang wrote:
>
>> On Thu, Jul 02, 2009 at 03:21:55PM +0800, Changli Gao wrote:
>> >fd leak if pipe() is called with an invalid address.
>> >
>> >Though -EFAULT is returned, the file descriptors opened by pipe() call
>> >are left open.
>> >
>> >Signed-off-by: Changli Gao <xiaosuo@gmail.com>
>> >----
>> >
>> > x86/ia32/sys_ia32.c     |    5 ++++-
>> > xtensa/kernel/syscall.c |    5 ++++-
>> > 2 files changed, 8 insertions(+), 2 deletions(-)
>> >
>> >
>> >--- arch/x86/ia32/sys_ia32.c.orig	2009-07-02 15:08:39.000000000 +0800
>> >+++ arch/x86/ia32/sys_ia32.c	2009-07-02 15:09:49.000000000 +0800
>> 
>> This patch is not correctly made... You need to make the patch in the
>> _upper_ directory of the top source code tree (if you don't use git),
>> so that we can apply it with 'patch -p1 < XXX'.
>> 
>> Probably this is the reason why Linus still doesn't merge it.


Hi, Linus.

>
>No, the main reason I haven't merged it is that I don't think the patch is 
>worth it. 
>
>If you give a bad area to pipe(), there's no point in closign the file 
>descriptors. It's a user-space bug. You got your file descriptors, you 
>just don't know what the hell they are, because your program is sh*t. 
>There's no point in the kernel trying to clean up, because the cleaned-up 
>state is not any better.

I totally agree that it is a user-space program's fault if it hits this,
but that doesn't mean we don't need to fix it in kernel, because logically
we are leaking fd's in that path.

Please also check sys_pipe2() in fs/pipe.c.

Thank you.

