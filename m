Return-Path: <linux-kernel-owner+w=401wt.eu-S1755156AbZIRCFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbZIRCFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 22:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbZIRCFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 22:05:18 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:63014 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbZIRCFQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 22:05:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pn+Or+jBq6GZof1YH297fLfTFnlrXh+gJE2H0ZKfqPxdNorBKiFc5lXePWqiy/hDSN
         GVmbpIFhQXS+liZOjSdHR27tKXVMPRaNzOOxLpctrXbBYHi2vqAhSTvzJnKhU6N+4Tir
         Mdtx6o8bo6RFtPVannxFmsO94/W96WBCCCY8M=
MIME-Version: 1.0
In-Reply-To: <20090917161432.97e06050.kamezawa.hiroyu@jp.fujitsu.com>
References: <2375c9f90909160235m1f052df0qb001f8243ed9291e@mail.gmail.com>
	 <1bc66b163326564dafb5a7dd8959fd56.squirrel@webmail-b.css.fujitsu.com>
	 <20090917114138.e14a1183.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090917114509.a9eb9f2c.kamezawa.hiroyu@jp.fujitsu.com>
	 <2375c9f90909162359m14ec7640m88ddd7ba54d6e793@mail.gmail.com>
	 <20090917161432.97e06050.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 18 Sep 2009 10:05:20 +0800
Message-ID: <2375c9f90909171905m66ff2005m16c5b3421aaf450@mail.gmail.com>
Subject: Re: [PATCH 3/3][mmotm] updateing size of kcore
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 3:14 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Thu, 17 Sep 2009 14:59:35 +0800
> Américo Wang <xiyou.wangcong@gmail.com> wrote:
>
>> On Thu, Sep 17, 2009 at 10:45 AM, KAMEZAWA Hiroyuki
>> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> >
>> > After memory hotplug (or other events in future), kcore size
>> > can be modified.
>> >
>> > To update inode->i_size, we have to know inode/dentry but we
>> > can't get it from inside /proc directly.
>> > But considerinyg memory hotplug, kcore image is updated only when
>> > it's opened. Then, updating inode->i_size at open() is enough.
>> >
>> > Cc: WANG Cong <xiyou.wangcong@gmail.com>
>> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>
>>
>> This patch looks fine.
>>
>> However, I am thinking if kcore is the only file under /proc whose size
>> is changed dynamically? If no, that probably means we need to change
>> generic proc code.
>>
> I tried yesteray, and back to this ;)
>
> One thing which makes me confused is that there is no way to get
> inode or dentry from proc_dir_entry.
>
> I tried to rewrite proc_getattr() for cheating "ls". But it just works for
> "stat" and inode->i_size is used more widely. So, this implementation now.

Yeah, stat->size is from inode->i_size.

>
> But considering practically, inode->i_size itself is not meaningful in /proc
> files even if it's correct. For example, /proc/vmstat or /proc/stat,
> /proc/<pid>/maps... etc...

Yes.

>
> inode->i_size will be dynamically changed while reading. Now, most of users
> know regular files under /proc is not a "real" file and handle them in proper
> way. (programs can be used with pipe/stdin works well.)
>
> I wonder /proc/kcore is a special one, which gdb/objdump/readelf may access.
> Above 3 programs are for "usual" files and not considering pseudo files under
> /proc. So, I think adding generic i->i_size support is an overkill until
> there are users depends on that.

At least I can't think out another /proc file as special as kcore. :-/

Thanks for your analysis, no problem with this patch.
