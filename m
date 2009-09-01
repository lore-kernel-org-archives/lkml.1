Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbZIAR4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbZIAR4G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 13:56:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbZIAR4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 13:56:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbZIAR4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 13:56:04 -0400
Message-ID: <4A9D600B.4020405@sandeen.net>
Date: Tue, 01 Sep 2009 12:55:23 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: Christoph Hellwig <hch@infradead.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>,
       Linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: xfs compat_ioctl?
References: <4A9B759B.7020401@msgid.tls.msk.ru>	<20090831123010.GA2368@infradead.org>	<64bb37e0908311114t4a3cefc3v8ea5092e1558c578@mail.gmail.com>	<20090831182754.GA3620@infradead.org> <64bb37e0909011000l78a0aef0wf4c53252c14af75e@mail.gmail.com>
In-Reply-To: <64bb37e0909011000l78a0aef0wf4c53252c14af75e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Torsten Kaiser wrote:
> On Mon, Aug 31, 2009 at 8:27 PM, Christoph Hellwig<hch@infradead.org> wrote:
>> I think you are right, the constant used is incorrect.  Does the small
>> patch below fix it for you?
> 
> Yes, after adding this patch, xfs_fsr works.

Crud, sorry about that.  I swear I ran 32-bit xfstests under a 64-bit
kernel, but I think we were lacking in fsr coverage....

-Eric

>> Index: linux-2.6/fs/xfs/linux-2.6/xfs_ioctl32.c
>> ===================================================================
>> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_ioctl32.c       2009-08-31 15:25:06.093044591 -0300
>> +++ linux-2.6/fs/xfs/linux-2.6/xfs_ioctl32.c    2009-08-31 15:25:10.856544216 -0300
>> @@ -619,7 +619,7 @@ xfs_file_compat_ioctl(
>>        case XFS_IOC_GETVERSION_32:
>>                cmd = _NATIVE_IOC(cmd, long);
>>                return xfs_file_ioctl(filp, cmd, p);
>> -       case XFS_IOC_SWAPEXT: {
>> +       case XFS_IOC_SWAPEXT_32: {
>>                struct xfs_swapext        sxp;
>>                struct compat_xfs_swapext __user *sxu = arg;
>>
>>
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

