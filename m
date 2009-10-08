Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbZJHKXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbZJHKXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 06:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755195AbZJHKXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 06:23:21 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:39353 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063AbZJHKXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 06:23:21 -0400
Date: Thu, 08 Oct 2009 19:22:42 +0900 (JST)
Message-Id: <20091008.192242.39182274.ryov@valinux.co.jp>
To: riel@redhat.com
Cc: vgoyal@redhat.com, nauman@google.com, m-ikeda@ds.jp.nec.com,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, agk@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu,
       yoshikawa.takuya@oss.ntt.co.jp
Subject: Re: IO scheduler based IO controller V10
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <4ACCC4B7.4050805@redhat.com>
References: <20091006112201.GA27866@redhat.com>
	<20091007.233805.183040347.ryov@valinux.co.jp>
	<4ACCC4B7.4050805@redhat.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rik,

Rik van Riel <riel@redhat.com> wrote:
> Ryo Tsuruta wrote:
> 
> > If once dm-ioband is integrated into the LVM tools and bandwidth can
> > be assigned per device by lvcreate, the use of dm-tools is no longer
> > required for users.
> 
> A lot of large data center users have a SAN, with volume management
> handled SAN-side and dedicated LUNs for different applications or
> groups of applications.
> 
> Because of alignment issues, they typically use filesystems directly
> on top of the LUNs, without partitions or LVM layers.  We cannot rely
> on LVM for these systems, because people prefer not to use that.

Thank you for your explanation. So I have a plan to reimplement
dm-ioband into the block layer to make dm-tools no longer required.
My opinion I wrote above assumes if dm-ioband is used for a logical
volume which consists of multiple physical devices. If dm-ioband is
integrated into the LVM tools, then the use of the dm-tools is not
required and the underlying physical devices can be automatically
deteced and configured to use dm-ioband.

Thanks,
Ryo Tsuruta

> Besides ... isn't the goal of the cgroups io bandwidth controller
> to control the IO used by PROCESSES?
>
> If we want to control processes, why would we want the configuration
> to be applied to any other kind of object in the system?
