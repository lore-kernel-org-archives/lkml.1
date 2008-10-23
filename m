Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbYJWNK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbYJWNK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 09:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbYJWNKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 09:10:16 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:42892 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbYJWNKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 09:10:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Ph6AEL8nIXocJUSWZawb5W1IDjnY3oNtqmkFmThaJ5eG/e1wifbEmIpX1kppkceyBK
         C+EvhURA+xzOvrTgncIKZesCJ8T7o+/NPeenj8MfFvHJeeLjgvC5MQGXKx5SXI6LJqib
         RVwns3fXKDPQhmI6AW+RzkbCJ5Tvr49W1s1+0=
Message-ID: <490077B4.5020909@gmail.com>
Date: Thu, 23 Oct 2008 15:10:12 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Johannes Weiner <hannes@saeurebad.de>
CC: Krzysztof Helt <krzysztof.h1@wp.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lockdep splat from fbmem
References: <87ljwgj8p1.fsf@saeurebad.de>
In-Reply-To: <87ljwgj8p1.fsf@saeurebad.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:
> Hi,
> 
> fb_mmap() is called under mmap_sem and acquires fb_info->lock.
> 
> Since 3e680aae4e53ab "fb: convert lock/unlock_kernel() into local fb
> mutex", fb_ioctl() takes fb_info->lock and does copy_to/from_user()
> under it, which in turn might acquire mmap_sem.
> 
> Just noticed the trace and wanted to let you know.
> 
>         Hannes

Good catch. We could try to push down the mutex and call all the
copy_to/from_user() outside the lock. I can try look at it tonight,
if someone doesn't fix it before.

Thanks for reporting,
-Andrea
