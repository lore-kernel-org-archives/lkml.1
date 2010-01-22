Return-Path: <linux-kernel-owner+w=401wt.eu-S1752653Ab0AVEmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab0AVEmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 23:42:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609Ab0AVEmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 23:42:24 -0500
Received: from mail-qy0-f194.google.com ([209.85.221.194]:41448 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab0AVEmY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 23:42:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Jc+NmhM+yyTq6F8/QU0fgmhCLupU+OyZGwES8mONL2NeYIKVlzxJYoISgyhEMdZt/R
         qSVD5s+5JjhfiiqCCpBciW9sBQGZhsglh5d6zk5fN7tAKYNhQG6QxQyfwfa1EvRAgDf0
         Fpt6QUVNd6lEvscGwY2yK8rNVi2G36Q3AcLdY=
MIME-Version: 1.0
In-Reply-To: <20100121155335.GB4471@osiris.boeblingen.de.ibm.com>
References: <20100121155335.GB4471@osiris.boeblingen.de.ibm.com>
Date: Fri, 22 Jan 2010 12:42:22 +0800
Message-ID: <2375c9f91001212042y6dceee1bl54bc564dea54f11b@mail.gmail.com>
Subject: Re: [2.6.33-rc4] sysfs lockdep warnings on cpu hotplug
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 11:53 PM, Heiko Carstens
<heiko.carstens@de.ibm.com> wrote:
> Hi Eric,
>
> rumours are that you could be responsible for the following lockdep message:
>
> Happens on cpu hotplug on s390:
>
> =============================================
> [ INFO: possible recursive locking detected ]
> 2.6.33-rc4-00399-g24bc734 #1
> ---------------------------------------------
> bash/2576 is trying to acquire lock:
>  (s_active){++++.+}, at: [<000000000016c506>] sysfs_addrm_finish+0x5a/0xa8
>
> but task is already holding lock:
>  (s_active){++++.+}, at: [<000000000016c90c>] sysfs_get_active_two+0x64/0x88
>
> other info that might help us debug this:
> 5 locks held by bash/2576:
>  #0:  (&buffer->mutex){+.+.+.}, at: [<000000000016a912>] sysfs_write_file+0x4a/0x1a8
>  #1:  (s_active){++++.+}, at: [<000000000016c90c>] sysfs_get_active_two+0x64/0x88
>  #2:  (s_active){++++.+}, at: [<000000000016c8e6>] sysfs_get_active_two+0x3e/0x88
>  #3:  (cpu_add_remove_lock){+.+.+.}, at: [<00000000003dd318>] cpu_down+0x44/0x88
>  #4:  (cpu_hotplug.lock){+.+.+.}, at: [<0000000000056eee>] cpu_hotplug_begin+0x3e/0x74
>

I think this is the same with the problem we met some days ago,

http://lkml.org/lkml/2010/1/10/282

does this patch from Erich help?

Thanks.
