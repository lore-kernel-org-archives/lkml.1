Return-Path: <linux-kernel-owner+w=401wt.eu-S1753389AbYICQ6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbYICQ6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 12:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbYICQ6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 12:58:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57415 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbYICQ6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 12:58:23 -0400
Message-ID: <48BEC1E7.2030306@zytor.com>
Date: Wed, 03 Sep 2008 09:57:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: device@lanana.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: regarding major number of block extended devt
References: <48BD30F9.6080108@kernel.org> <48BD3313.7090906@kernel.org> <48BD9F36.8000704@zytor.com> <48BE0EDB.20107@kernel.org> <48BEB759.4050503@zytor.com> <48BEB98C.8030303@kernel.org> <48BEBAF0.7070008@zytor.com> <48BEBF34.50006@kernel.org>
In-Reply-To: <48BEBF34.50006@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Then, we're between the rock and hard place then as there also is a
> lot of code which assumes certain layout of sd or hd minor numbers.
> Keeping only the major numbers doesn't really resolve any problem.  It
> may be able to mask a few but that can be more harmful than helpful.
> 
> So, if a program expects certain major numbers, it won't be able to
> access the partitions which have overflowed to the extended area.  If
> a program uses udev or sys hierarchy to walk through devices, it will
> be able to use them all.  Isn't that much better than overflowing into
> the same major and hope that everything would work out okay?

Oh dear...

I just realized that you're talking about *partitions*, not *devices*. 
There is a metric boatload of code out there that assumes you can take a 
device number, mask off some number of bits, and reach the parent 
device.  They will generally do that without checking if they are right 
or not.

As such, you're liable to suffer corruption of unrelated devices.

In that sense, yes, a separate major will help somewhat.

	-hpa

