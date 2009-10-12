Return-Path: <linux-kernel-owner+w=401wt.eu-S1757673AbZJLSit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673AbZJLSit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 14:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757658AbZJLSis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 14:38:48 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:37788 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757646AbZJLSis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 14:38:48 -0400
Message-ID: <4AD37790.8090404@garzik.org>
Date: Mon, 12 Oct 2009 14:38:08 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Linux Kernel Mailing <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: blkdev_issue_flush really issues a WRITE_BARRIER -- is that okay?
References: <x49hbu4semq.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49hbu4semq.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2009 01:31 PM, Jeff Moyer wrote:
> Hi,
>
> While looking though Christoph's patch to call blkdev_issue_flush for
> fsync on block devices, I noticed that it only issues a WRITE_BARRIER.
> I don't see how that guarantees that data is on stable storage.  Am I
> missing something?  Shouldn't this translate to a FLUSH CACHE or
> SYNCHRONIZE CACHE command?

Barriers are a high level primitive that exist at the block layer level.

Lower level storage drivers then convert barriers to a hardware-specific 
low level primitive such as SYNCHRONIZE CACHE or FUA.

	Jeff


