Return-Path: <linux-kernel-owner+w=401wt.eu-S1754434AbZGOLw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbZGOLw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 07:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754396AbZGOLw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 07:52:28 -0400
Received: from smtp.nokia.com ([192.100.122.233]:22311 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354AbZGOLw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 07:52:27 -0400
Subject: Re: Mounting more than one ubifs fails on 2.6.31-rc2
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Tobias Diedrich <ranma+kernel@tdiedrich.de>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
In-Reply-To: <20090715113210.GB16289@yamamaya.is-a-geek.org>
References: <20090715113210.GB16289@yamamaya.is-a-geek.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Jul 2009 14:52:11 +0300
Message-Id: <1247658731.11353.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 15 Jul 2009 11:52:13.0594 (UTC) FILETIME=[B16977A0:01CA0542]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-15 at 13:32 +0200, Tobias Diedrich wrote:
> I get the following error when trying to mount a second ubifs:
> "mount: File exists"
> Apparently the problem is that ubifs is registered in /sys/class/bdi
> with it's name 'ubifs' instead of the ubi device major/minor and
> so can only be registered once.
> 
> navi:/home/ranma# mount -t ubifs ubi1:rootfs /mnt/ubi1
> navi:/home/ranma# mount -t ubifs ubi0:rootfs /mnt/ubi0
> mount: File exists
> navi:/home/ranma# umount /mnt/ubi1
> navi:/home/ranma# mount -t ubifs ubi0:rootfs /mnt/ubi0
> navi:/home/ranma# mount -t ubifs ubi1:rootfs /mnt/ubi1
> mount: File exists
> 
> The corresponding kernel error messages is:
> sysfs: cannot create duplicate filename '/class/bdi/ubifs'
> 

Was fixed recently:

http://git.infradead.org/ubifs-2.6.git?a=commit;h=7fcd9c3ecbf09c0a77db7ba01aac75b32fb79a93

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

