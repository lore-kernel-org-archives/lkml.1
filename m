Return-Path: <linux-kernel-owner+w=401wt.eu-S1756345AbXKKAWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbXKKAWd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 19:22:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755641AbXKKAWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 19:22:25 -0500
Received: from bravo667.server4you.de ([85.25.132.126]:46733 "EHLO
	mail.sitenet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556AbXKKAWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 19:22:25 -0500
Message-ID: <47364B57.5010409@czajsoft.pl>
Date: Sun, 11 Nov 2007 01:22:47 +0100
From: Przemyslaw Wegrzyn <czajnik@czajsoft.pl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Steve French <smfrench@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, joern@logfs.org,
       linux-cifs-client@lists.samba.org
Subject: Re: Fw: Buffer overflow in CIFS VFS.
References: <OFA6B04F1D.DE8E7DD9-ON8725738E.00065BC2-8625738E.00066CD4@us.ibm.com>	 <524f69650711081812j20580247kce68334b778c73c7@mail.gmail.com>	 <47343DA2.90306@czajsoft.pl>	 <524f69650711091444t4d02e6d8g7dd15dbe2637d714@mail.gmail.com>	 <4735AC13.9030206@czajsoft.pl> <524f69650711101154s67e19fe6wa1803b8ded2ff632@mail.gmail.com>
In-Reply-To: <524f69650711101154s67e19fe6wa1803b8ded2ff632@mail.gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steve French wrote:
> On Nov 10, 2007 7:03 AM, Przemyslaw Wegrzyn <czajnik@czajsoft.pl> wrote:
>   
>> Steve French wrote:
>>     
>>> That might be better, although without memory pools, this would perform
>>> much worse
>>>
>>>       
>> Why ? I don't get your point here.
>>     
> What I meant is that two fixed size memory pools rather variable size
> kmallocs helps performance.  By using two fixed size buffers (small -
> which fits the typical smb request and response, and large which fits
> the maximum size request other than write which is handled via an
> iovec) and taking advantage of memory pools, cifs can always make
> progress even in low memory situations (reducing the likelihood of
> deadlock) and it reduces the number of times that cifs has to do the
> very expensive allocation of 16.5K.  If cifs only used variable size
> request and response buffers, since they are frequently more than one
> page in size we would be forcing the memory manager to find contiguous
> pages which can be very slow.
>   
That was not really my intention to allocate variable size buffers -
it's perfectly Ok for me to have 2 fixed-size pools. What I meant was to
allocate buffers with some kind of header containing buffer size and
type of buffer or whatever needed info. Obviously, you could use
pointers to buffer body all over the code, functions/macros that need to
access the header would move the pointer back by sizeof(header). Then
one could e.g. provide a single function for disposing the buffer, and
no longer care which pool is it allocated from, for the additional
memory cost - the function would look into the header to check that for
you. Hope it's clear now (my English is far from perfect).

Przemyslaw

