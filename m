Return-Path: <linux-kernel-owner+w=401wt.eu-S1754602AbYJNJUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbYJNJUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 05:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754841AbYJNJUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 05:20:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:38394 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754847AbYJNJT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 05:19:59 -0400
Message-ID: <48F463C4.3070405@kernel.org>
Date: Tue, 14 Oct 2008 18:17:56 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: kenneth johansson <ken@kenjo.org>
CC: Grant Grundler <grundler@google.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: weird throughput on write to SATA disk
References: <1223925629.3947.7.camel@duo>	 <da824cf30810131407m1a73bd11xa30fd118ee5a4c8f@mail.gmail.com>	 <1223932956.3947.22.camel@duo>	 <da824cf30810131434r34179666kc8d075c7eecdbbae@mail.gmail.com>	 <1223936351.3947.41.camel@duo>	 <da824cf30810131833g6e509d0dvb6cce6c7220a1a28@mail.gmail.com> <1223975694.3947.77.camel@duo>
In-Reply-To: <1223975694.3947.77.camel@duo>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Oct 2008 09:19:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kenneth johansson wrote:
> On Mon, 2008-10-13 at 18:33 -0700, Grant Grundler wrote:
>> On Mon, Oct 13, 2008 at 3:19 PM, kenneth johansson <ken@kenjo.org> wrote:
>> ...
>>>> Can you try "dd oflag=direct if=/dev/null of=/dev/sdb bs=64k"?
>>> I changed to use O_DIRECT and it's much more consistent now. 69-75 with
>>> 74 about 95% of the time.
>> That's low but it could be worse. Many things can contribute to slow
>> disks. 
> Well my main problem was that it was fluctuating so much that can't be
> right. 
> 
>> Favorites are overtemp (See SMART field 194) and vibration (no
>> measurement possible w/o special equipment). "dd" isn't exactly a
>> performance application until one uses really big block sizes (1MB or
>> larger).
> All my numbers comes from using 1MB blocks. but I'm not using dd.
> After removing the logic that actually put some data into the buffers I
> do get about 105 MB/sec using O_DIRECT. I'm doing a full disk write now
> to get a reference plot. Not using O_DIRECT should be almost identical. 
> 
> 
>>> the disk is supposed to have 105 115 sustained
>>> data rate.
>> Where did 105-115 number come from?
> datasheet . they listed two drives in the same column so that was not
> the range it was sustained OD and the model I have max out at 105. 

Can you try deadline scheduler?

-- 
tejun
