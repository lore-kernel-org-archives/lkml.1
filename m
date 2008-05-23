Return-Path: <linux-kernel-owner+w=401wt.eu-S1759715AbYEWBUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759715AbYEWBUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 21:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbYEWBUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 21:20:24 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:10723 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbYEWBUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 21:20:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rSS+mvT9cEku4/Ype6H3t8vVyzik2dPfsHC6vfZwE4mHduvky/izw/8wj6KB2rlgFeHYdOm7JZg/nA2k8ZrPHwQ+HjqcmnrCId6wKYtqyn6TEz/TJrcdZKgI82TP+DPP6pYadWICFBYDXbC6+Ung2gLXZ4mi2RUyo1ppjRVBYDM=
Message-ID: <6f4bf7350805221820p905e9b5n788ca42cab20cfaf@mail.gmail.com>
Date: Fri, 23 May 2008 09:20:21 +0800
From: "XiongJia Le" <lexiongjia@gmail.com>
To: "TJ Easter" <tjeaster@gmail.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: How to filter the Block I/O in 2.6 kernel?
In-Reply-To: <1d4539510805220957s6954ac7as117cca02bb2077ca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6f4bf7350805202105g2594d85dt1ae3b650e3e3671@mail.gmail.com>
	 <1d4539510805220957s6954ac7as117cca02bb2077ca@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi TJ,

I am working on a small tools what can dump all occupied sectors on
the hard disk.
But at dumping time some i/o is still occuring on the disk. So I want
to write a filter in kernel.
If some sector will change at dumping time, I will dump this sector
first and before this sector changed.

I think hook syscall is not enough for me. Because at System Call
layout I can not get the address of the sector what will changed.

Thanks,
Xiongjia Le


On Fri, May 23, 2008 at 12:57 AM, TJ Easter <tjeaster@gmail.com> wrote:
> XiongJia,
>      I am far from a kernel expert, but something you might consider would
> be to write a module that hooks the syscall(s) for I/O, replacing them with
> your own routines, and then passing the altered data along to the original
> syscall.  I am not sure that a module will allow you that deep of access
> into the I/O paths, but it might be your easiest option.    If I may ask,
> why would you want to alter data between the I/O scheduler and the actual
> disk store?   Seems somewhat counter-intuitive to me.
>
> Regards,
> TJ Easter
>
> On Tue, May 20, 2008 at 11:05 PM, XiongJia Le <lexiongjia@gmail.com> wrote:
>>
>> How to filter the Block I/O in 2.6 kernel?
>>
>> I have looked some in blktrace.
>> blktrace can trace the block device I/O info. But that can't
>> filter/change this I/O.
>>
>> Is the Linux kernel have any way to filter/change a block i/o before
>> it write to hard disk?
>> I don't want to change kernel code and re-build. Is Kernel already
>> have any I/O filter interface?
>>
>> Thanks,
>> Xiongjia Le
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> "Being a humanist means trying to behave decently without expectation of
> rewards or punishment after you are dead."  -- Kurt Vonnegut, 1922 - 2007
> http://keyserver1.pgp.com/vkd/DownloadKey.event?keyid=0x5EB6E92FE2340DEF
