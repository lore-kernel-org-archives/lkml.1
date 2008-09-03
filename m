Return-Path: <linux-kernel-owner+w=401wt.eu-S1753454AbYICQrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbYICQrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 12:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbYICQrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 12:47:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:50949 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840AbYICQrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 12:47:09 -0400
Message-ID: <48BEBF34.50006@kernel.org>
Date: Wed, 03 Sep 2008 18:45:40 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: device@lanana.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: regarding major number of block extended devt
References: <48BD30F9.6080108@kernel.org> <48BD3313.7090906@kernel.org> <48BD9F36.8000704@zytor.com> <48BE0EDB.20107@kernel.org> <48BEB759.4050503@zytor.com> <48BEB98C.8030303@kernel.org> <48BEBAF0.7070008@zytor.com>
In-Reply-To: <48BEBAF0.7070008@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 03 Sep 2008 16:46:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Tejun Heo wrote:
>> To use ext devt, the system has to use udev for device numbers.  As long
>> as udev is used, the major number doesn't matter.
> 
> I'm sorry, but that's simply false.  There is a *lot* of code out there
> that assumes you can determine what the device is by correlating the
> major number with /proc/devices.

Then, we're between the rock and hard place then as there also is a
lot of code which assumes certain layout of sd or hd minor numbers.
Keeping only the major numbers doesn't really resolve any problem.  It
may be able to mask a few but that can be more harmful than helpful.

So, if a program expects certain major numbers, it won't be able to
access the partitions which have overflowed to the extended area.  If
a program uses udev or sys hierarchy to walk through devices, it will
be able to use them all.  Isn't that much better than overflowing into
the same major and hope that everything would work out okay?

Thanks.

-- 
tejun
