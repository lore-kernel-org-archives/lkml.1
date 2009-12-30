Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbZL3UbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbZL3UbI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 15:31:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbZL3UbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 15:31:07 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:53897 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbZL3UbG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 15:31:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Am2H7XFZkG+2eljWJ1EJk2n5HO1mL+Ay29cTKXPT8uTg3fIGyspzsMS+oC5SY/kmC2
         VgDq2XDD/hmqniB6jPvlhYwx2zWZMPjtzuDV3G+tLypW9uH4VpYlDTnkDQxLLQp03FJB
         R8r2NmK5RfyqguzwsVzpTyvlnlHyuvB6GSf/A=
MIME-Version: 1.0
In-Reply-To: <20091230184535.GE4489@kernel.dk>
References: <1262175004-2132-1-git-send-email-czoccolo@gmail.com>
	 <20091230184535.GE4489@kernel.dk>
Date: Wed, 30 Dec 2009 21:31:03 +0100
Message-ID: <4e5e476b0912301231k3214bb3dicbfc59d94623d72@mail.gmail.com>
Subject: Re: [PATCH] cfq-iosched: non-rot devices do not need queue merging
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 30, 2009 at 7:45 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Wed, Dec 30 2009, Corrado Zoccolo wrote:
>> Non rotational devices' performances are not affected by
>> distance of requests, so there is no point in having overhead
>> to merge queues of nearby requests.
>
> If the distance is zero, it may still make a big difference (at least
> for writes). This check would be better as "ncq and doesn't suck", ala
>
>        blk_queue_nonrot(q) && tagged
>
> like we do elsewhere.

For reads, though, even flash cards and netbook ssds are completely
unaffected. I have done few experiments on my available disks:
* http://dl.dropbox.com/u/3525644/service_time.png (I used the
program: http://dl.dropbox.com/u/3525644/stride.c to get the graphs).

For distance 0, I think request merging will be more effective than
queue merging, moreover I think the multi-thread trick to have large
I/O depth is used for reads, not writes (where simply issuing buffered
writes already achieves a similar effect), so I think it is safe to
disable it for all non-rotational devices.

Thanks,
Corrado
>
> --
> Jens Axboe
>
>
