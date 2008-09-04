Return-Path: <linux-kernel-owner+w=401wt.eu-S1754552AbYIDApB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbYIDApB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 20:45:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbYIDAow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 20:44:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50056 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbYIDAow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 20:44:52 -0400
Message-ID: <48BF2F40.5050906@zytor.com>
Date: Wed, 03 Sep 2008 17:43:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: device@lanana.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: regarding major number of block extended devt
References: <48BD30F9.6080108@kernel.org> <48BD3313.7090906@kernel.org> <48BD9F36.8000704@zytor.com> <48BE0EDB.20107@kernel.org> <48BEB759.4050503@zytor.com> <48BEB98C.8030303@kernel.org> <48BEBAF0.7070008@zytor.com> <48BEBF34.50006@kernel.org> <48BED351.1060300@zytor.com> <48BF2AEB.1050508@kernel.org> <48BF2BAC.9070508@zytor.com> <48BF2D4E.4090906@kernel.org>
In-Reply-To: <48BF2D4E.4090906@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> H. Peter Anvin wrote:
>> Note that addition /partitions/ is somewhat unlikely to be useful, since
>> existing code will have to search through random crap in sysfs to look
>> for the partition directories anyway.
> 
> Currently it has to list /sys/block/DEV/DEV[-]N/.  With proper
> classification, it can do /sys/block/*/partitions/*.  We'll need to keep
> around symlinks at the root level.  It also plays well with how other
> subsystems have been changing.
> 

Yes, my point was mostly that in order to support older kernels, most 
code is going to want to just access /sys/block/DEV/DEV*N/ anyway.  What 
I have done in my code is I do a readdir() on /sys/block/DEV and look 
for subdirectories with a "dev" member.

Changing them to symlinks would actually break at least my code 
(arguably bad programming on my part), since  optimize by looking for 
DT_DIR.

	-hpa
