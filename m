Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbYA2GnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbYA2GnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 01:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbYA2GnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 01:43:10 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53445 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbYA2GnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 01:43:09 -0500
Message-ID: <479ECAC9.5070709@jp.fujitsu.com>
Date: Tue, 29 Jan 2008 15:42:17 +0900
From: INAKOSHI Hiroya <inakoshi.hiroya@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.8.1.9) Gecko/20071031 Thunderbird/2.0.0.9 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Subject: Re: [Xen-devel] dm-band: The I/O bandwidth controller: Performance
 Report
References: <20080123.215350.193721890.ryov@valinux.co.jp> <20080125.160720.183032233.ryov@valinux.co.jp>
In-Reply-To: <20080125.160720.183032233.ryov@valinux.co.jp>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ryo Tsuruta wrote:
> The results of bandwidth control test on band-groups.
> =====================================================
> The configurations of the test #3:
>    o Prepare three partitions sdb5 and sdb6.
>    o Create two extra band-groups on sdb5, the first is of user1 and the
>      second is of user2.
>    o Give weights of 40, 20, 10 and 10 to the user1 band-group, the user2
>      band-group, the default group of sdb5 and sdb6 respectively.
>    o Run 128 processes issuing random read/write direct I/O with 4KB data
>      on each device at the same time.

you mean that you run 128 processes on each user-device pairs?  Namely,
I guess that

  user1: 128 processes on sdb5,
  user2: 128 processes on sdb5,
  another: 128 processes on sdb5,
  user2: 128 processes on sdb6.

> Conclusions and future works
> ============================
> Dm-band works well with random I/Os. I have a plan on running some tests
> using various real applications such as databases or file servers.
> If you have any other good idea to test dm-band, please let me know.

The second preliminary studies might be:

- What if you use a different I/O size on each device (or device-user pair)?
- What if you use a different number of processes on each device (or
device-user pair)?


And my impression is that it's natural dm-band is in device-mapper,
separated from I/O scheduler.  Because bandwidth control and I/O
scheduling are two different things, it may be simpler that they are
implemented in different layers.

Regards,

Hiroya.


> 
> Thank you,
> Ryo Tsuruta.
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
> 
> 

