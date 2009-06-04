Return-Path: <linux-kernel-owner+w=401wt.eu-S1757186AbZFDPSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbZFDPSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 11:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754189AbZFDPSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 11:18:25 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:53771 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbZFDPSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 11:18:25 -0400
From: Goswin von Brederlow <goswin-v-b@web.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: goswin-v-b@web.de, linux-kernel@vger.kernel.org
Subject: Re: include/linux/aio_abi.h and IOCB_CMD_POLL
References: <87d49k6h45.fsf@frosties.localdomain>
	<E1MCCnb-0005Bc-09@pomaz-ex.szeredi.hu>
Date: Thu, 04 Jun 2009 17:18:24 +0200
In-Reply-To: <E1MCCnb-0005Bc-09@pomaz-ex.szeredi.hu> (Miklos Szeredi's message
	of "Thu, 04 Jun 2009 15:16:03 +0200")
Message-ID: <87hbyw6n9b.fsf@frosties.localdomain>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.22 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Provags-ID: V01U2FsdGVkX186VDiHoOe8sS+c3z3lp6buMNgDOBY7+VyUXv1q
	NVz99ZnjshOI/vV4X/4Xj+cya9iSW3B2dCYS7bRO2kEsUM2JPr
	IKOk0+QK8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> On Thu, 04 Jun 2009, Goswin von Brederlow wrote:
>> 3) Are there any alternatives to libaio that don't use threads and
>>    support polling?
>
> There are the poll, select and epoll interfaces that block, but are
> able to multiplex events from many file descriptors.

Unfortunately libaio does not use an fd to pass events between user
and kernel space so one can't use poll, select or epoll to wait for
/dev/fuse or libaio to have some work pending. And none of them
replace libaio functionality in respect to read/write.

And alternating between io_getevents and e.g. select with a tiny
timeout seems like a verry bad idea efficiency wise.

> And there's the O_ASYNC flag that can be set with an fcntl(), that
> sends a SIGIO signal on an I/O event.

This might work together with libaio. Never used SIGIO though but I
will try. Thanks for the idea.

> All of these work on /dev/fuse.
>
> Thanks,
> Miklos

MfG
        Goswin
