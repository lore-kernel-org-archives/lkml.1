Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbYKDXXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbYKDXXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:23:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754049AbYKDXXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:23:46 -0500
Received: from gw.goop.org ([64.81.55.164]:43095 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286AbYKDXXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:23:45 -0500
Message-ID: <4910D97E.2030203@goop.org>
Date: Tue, 04 Nov 2008 15:23:42 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       jeremy@xensource.com
Subject: Re: [PATCH 1/3] block: add queue flag for paravirt frontend drivers
References: <1219754894.7235.44.camel@sebastian.kern.oss.ntt.co.jp> <20080826143900.GM20055@kernel.dk> <1219814047.18991.52.camel@sebastian.kern.oss.ntt.co.jp> <1225100686.7370.79.camel@sebastian.kern.oss.ntt.co.jp> <20081027125624.GA22217@kernel.dk>
In-Reply-To: <20081027125624.GA22217@kernel.dk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Mon, Oct 27 2008, Fernando Luis Vázquez Cao wrote:
>   
>> As is the case with SSD devices, we do not want to idle in AS/CFQ when
>> the block device is a paravirt front-end driver. This patch adds a flag
>> (QUEUE_FLAG_VIRT) which should be used by front-end drivers such as
>> virtio_blk and xen-blkfront to indicate a paravirtualized device.
>>     
>
> All three patches look fine, although we could just reuse
> QUEUE_FLAG_NONROT directly. But I agree it makes sense to make the
> distinction, so I've just applied 1-3.
>   

I guess in theory you could imagine that the virtual device is mapped 
directly onto a physical device, and the host OS does no scheduling, in 
which case it would be appropriate for the guest do the work.  But I 
think otherwise this makes sense.

    J
