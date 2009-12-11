Return-Path: <linux-kernel-owner+w=401wt.eu-S932797AbZLKVZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797AbZLKVZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 16:25:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758877AbZLKVZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 16:25:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758850AbZLKVZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 16:25:35 -0500
Message-ID: <4B22B89A.3060009@redhat.com>
Date: Fri, 11 Dec 2009 16:24:42 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: lwoodman@redhat.com, kosaki.motohiro@jp.fujitsu.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, aarcange@redhat.com
Subject: Re: [PATCH] vmscan: limit concurrent reclaimers in shrink_zone
References: <20091210185626.26f9828a@cuia.bos.redhat.com> <28c262360912101803i7b43db78se8cf9ec61d92ee0f@mail.gmail.com>
In-Reply-To: <28c262360912101803i7b43db78se8cf9ec61d92ee0f@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2009 09:03 PM, Minchan Kim wrote:
> On Fri, Dec 11, 2009 at 8:56 AM, Rik van Riel<riel@redhat.com>  wrote:
>> Under very heavy multi-process workloads, like AIM7, the VM can
>> get into trouble in a variety of ways.  The trouble start when
>> there are hundreds, or even thousands of processes active in the
>> page reclaim code.

> Otherwise looks good to me.
>
> Reviewed-by: Minchan Kim<minchan.kim@gmail.com>

OK, we found three issues with my patch :)

1) there is a typo in sysctl.c

2) there is another typo in Documentation/vm/sysctl.c

3) the code in vmscan.c has a bug, where tasks without
     __GFP_IO or __GFP_FS can end up waiting for tasks
     with __GFP_IO or __GFP_FS, leading to a deadlock

I will fix these issues and send out a new patch.

-- 
All rights reversed.
