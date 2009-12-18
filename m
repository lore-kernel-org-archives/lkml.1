Return-Path: <linux-kernel-owner+w=401wt.eu-S1756361AbZLREjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361AbZLREjz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 23:39:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755786AbZLREjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 23:39:54 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:56449 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293AbZLREjw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 23:39:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HyJENcqfEsOKjsGMOfWflwa+s72WMwDhFOIMQAz9pZJcY/Cj0jW20TCsD0nyBud1tS
         HZjfXJvM5hmxpHEhbSvvPXEkA1LqeEYnapPGDJYDdf9Bw1GhF/YuHwY+ClEG0pYNYae7
         aU9nCFwVW31YQQAyccjtPZjEOwzkn2urT9Mt4=
MIME-Version: 1.0
In-Reply-To: <4B2ADB4C.7010900@cn.fujitsu.com>
References: <4B2ADB4C.7010900@cn.fujitsu.com>
Date: Fri, 18 Dec 2009 12:39:50 +0800
Message-ID: <9bd6b5360912172039y432361fu243d0f05bf75b7b7@mail.gmail.com>
Subject: Re: [PATCH] btrfs: Simplify offset calculation method for ctree.h
From: sniper <s3c24xx@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No, many pointers in btrfs function arguments are not pointing to an
absolute address, but relative to the start address of extent.

Take following function as example, argument inode_item is an offset
value to the beginning of leaf. So we can't reach its member with
&inode_item->xxx

>  static inline struct btrfs_timespec *
>  btrfs_inode_mtime(struct btrfs_inode_item *inode_item)
>  {
> -       unsigned long ptr = (unsigned long)inode_item;
> -       ptr += offsetof(struct btrfs_inode_item, mtime);
> -       return (struct btrfs_timespec *)ptr;
> +       return &inode_item->mtime;
>  }
