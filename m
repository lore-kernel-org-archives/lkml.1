Return-Path: <linux-kernel-owner+w=401wt.eu-S1759840AbYD2IOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759840AbYD2IOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 04:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755247AbYD2IN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 04:13:59 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:50068 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbYD2IN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 04:13:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:x-x-sender:to:cc:subject:in-reply-to:message-id:references:user-agent:mime-version:content-type:from;
        b=WPVJ5C+0LncV01KEtCSaxm0+UlOnDxwhIUTcy5+OA6DXxOPQitr52ozTTXvQtKsQr/N4ST4s9QxJuAtLlzAwQSHB0WQXbMXA6QMRf+EMGquZFCYlaTOSutUtSwUR7tUm4Ak3J6kkCTEcgWIEIYRuaYz16vtrR/9uxB5ijWV2KmM=
Date: Tue, 29 Apr 2008 16:12:55 +0800 (CST)
X-X-Sender: wangcong@localhost.localdomain
To: Jeff Dike <jdike@addtoit.com>
cc: WANG Cong <xiyou.wangcong@gmail.com>, akpm@osdl.org,
       linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 7/19] UML - Move hppfs_kern.c to hppfs.c
In-Reply-To: <20080428153716.GC7334@c2.user-mode-linux.org>
Message-ID: <alpine.LFD.1.00.0804291610070.2548@localhost.localdomain>
References: <20080425175609.GA11180@c2.user-mode-linux.org> <20080426.171755.99884416.xiyou.wangcong@gmail.com> <20080428153716.GC7334@c2.user-mode-linux.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
From: WANG Cong <xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008, Jeff Dike wrote:

> On Sat, Apr 26, 2008 at 05:17:55PM +0800, WANG Cong wrote:
>> > +static struct inode *get_inode(struct super_block *, struct dentry *);
>> > +
>> > +struct hppfs_data {
>> > +	struct list_head list;
>> > +	char contents[PAGE_SIZE - sizeof(struct list_head)];
>> > +};
>> > +
>> > +struct hppfs_private {
>> > +	struct file *proc_file;
>> > +	int host_fd;
>> > +	loff_t len;
>> > +	struct hppfs_data *contents;
>> > +};
>> > +
>> > +struct hppfs_inode_info {
>> > +	struct dentry *proc_dentry;
>> > +	struct inode vfs_inode;
>> > +};
>> > +
>> > +static inline struct hppfs_inode_info *HPPFS_I(struct inode *inode)
>> > +{
>> > +	return container_of(inode, struct hppfs_inode_info, vfs_inode);
>> > +}
>> > +
>> > +#define HPPFS_SUPER_MAGIC 0xb00000ee
>> 
>> 
>> These can be put into a single header, e.g. hppfs.h.
>
> Why, when this one C file is the only user?

Just looks cleaner for me. ;-)

<snip>

>
> Oops, nice spotting.
>
> See what you think about the patch below...

<snip>

This patch looks OK for me. Thank you!

  Cong
