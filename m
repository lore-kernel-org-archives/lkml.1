Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511Ab0CJRKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 12:10:07 -0500
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4062 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489Ab0CJRKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 12:10:04 -0500
Message-ID: <4B97D258.7060702@gmail.com>
Date: Wed, 10 Mar 2010 18:09:44 +0100
From: M vd S <mvds.00@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: O_NONBLOCK is NOOP on block devices
References: <4B904D98.50602@gmail.com> <4B9060DE.4080104@gmail.com>	<4B96ECDD.1070006@gmail.com> <x494oko5n2o.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x494oko5n2o.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/10/10 2:21 PM, Jeff Moyer wrote:
> M vd S <mvds.00@gmail.com> writes:
>   
>> I also briefly tried aio_* and the libaio interface. The former is not
>> really asynchronous - all requests are put in one separate thread
>> where they will be executed in order, i.e. blocking, so you don't get
>> any advantage from NCQ or data that was cached by the disk or the
>> kernel. The latter apparently ends in an io_submit() which will block
>> until all queued reads are finished, but I might have missed something
>> there.
>>     
>
> What you missed is that the native aio system calls require O_DIRECT.
>   

Thanks, that made it work. It seems without O_DIRECT it's just like 
aio_* but without the separate thread. But I now get the "benefits" of 
O_DIRECT for free...

Cheers,
M.

