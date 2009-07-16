Return-Path: <linux-kernel-owner+w=401wt.eu-S932425AbZGPOyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425AbZGPOyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 10:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932366AbZGPOyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 10:54:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:50207 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326AbZGPOyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 10:54:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ctbLyrLz/jE0W8beFjPuRa5KrJ3TvGP9Wp/IdwcVKPiuOrSDo6MB79VMk5F6JZIpji
         Q5tCZcsH2VjNxWUNLG5OZlS+L7g5xzIOuOWAio2naGqBrUNGR9xufYyTv1NLmPq5tPfZ
         CVdVYG3byNaqMmEbLZhyLhfCaQuu7VK2DTbkY=
MIME-Version: 1.0
In-Reply-To: <4A5F0293.3010206@vlnb.net>
References: <4A3CD62B.1020407@vlnb.net> <4A5493A8.2000806@vlnb.net>
	 <a0272b440907092332o7c5bf1d0oa51d1cfc9b9e98f5@mail.gmail.com>
	 <4A56FF32.2060303@vlnb.net> <4A570981.5080803@vlnb.net>
	 <a0272b440907130512y60a757afqd5629f4ca3ac8e1b@mail.gmail.com>
	 <4A5CD3E2.2060307@vlnb.net> <4A5D7794.2070607@vlnb.net>
	 <a0272b440907160032u482bd483s54540001aef7ac73@mail.gmail.com>
	 <4A5F0293.3010206@vlnb.net>
Date: Thu, 16 Jul 2009 16:54:44 +0200
Message-ID: <a0272b440907160754j3545f4dby13882ea1ab964222@mail.gmail.com>
Subject: Re: [RESEND] [PATCH] readahead:add blk_run_backing_dev
From: Ronald Moesbergen <intercommit@gmail.com>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: fengguang.wu@intel.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       Alan.Brunelle@hp.com, linux-fsdevel@vger.kernel.org,
       jens.axboe@oracle.com, randy.dunlap@oracle.com,
       Bart Van Assche <bart.vanassche@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/16 Vladislav Bolkhovitin <vst@vlnb.net>:
>
> Ronald Moesbergen, on 07/16/2009 11:32 AM wrote:
>>
>> 2009/7/15 Vladislav Bolkhovitin <vst@vlnb.net>:
>>>>
>>>> The drop with 64 max_sectors_kb on the client is a consequence of how
>>>> CFQ
>>>> is working. I can't find the exact code responsible for this, but from
>>>> all
>>>> signs, CFQ stops delaying requests if amount of outstanding requests
>>>> exceeds
>>>> some threshold, which is 2 or 3. With 64 max_sectors_kb and 5 SCST I/O
>>>> threads this threshold is exceeded, so CFQ doesn't recover order of
>>>> requests, hence the performance drop. With default 512 max_sectors_kb
>>>> and
>>>> 128K RA the server sees at max 2 requests at time.
>>>>
>>>> Ronald, can you perform the same tests with 1 and 2 SCST I/O threads,
>>>> please?
>>
>> Ok. Should I still use the file-on-xfs testcase for this, or should I
>> go back to using a regular block device?
>
> Yes, please

As in: Yes, go back to block device, or Yes use file-on-xfs?

>> The file-over-iscsi is quite
>> uncommon I suppose, most people will export a block device over iscsi,
>> not a file.
>
> No, files are common. The main reason why people use direct block devices is
> a not supported by anything believe that comparing with files they "have
> less overhead", so "should be faster". But it isn't true and can be easily
> checked.

Well, there are other advantages of using a block device: they are
generally more manageble, for instance you can use LVM for resizing
instead of strange dd magic to extend a file. When using a file you
have to extend the volume that holds the file first, and then the file
itself. And you don't lose disk space to filesystem metadata twice.
Also, I still don't get why reads/writes from a blockdevice are
different in speed than reads/writes from a file on a filesystem. I
for one will not be using files exported over iscsi, but blockdevices
(LVM volumes).

Ronald.
