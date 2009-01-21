Return-Path: <linux-kernel-owner+w=401wt.eu-S1763818AbZAUJDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763818AbZAUJDl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 04:03:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbZAUJDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 04:03:25 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:41018 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662AbZAUJDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 04:03:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=A7yvIzO3gkSXjDCKoCTYyGEp1iioGTQX5xEKl2UAEhwfuv6r53nms34SXnnsdImP1J
         CBCijT1hbiXgEKpN0gZFqYgELQhqk6xRW/L/r0q0l3nopnRluFueyyPTS48UUAKcowxi
         GKkTarjAp5ceerT256BO+GfW1ks6DvSL/1Nc8=
Message-ID: <4976E524.1050607@gmail.com>
Date: Wed, 21 Jan 2009 10:04:36 +0100
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: Jacek Luczak <difrost.kernel@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>,
       xfs mailing list <xfs@oss.sgi.com>
Subject: Re: [XFS] 2.6.29-rc2: XFS internal error XFS_WANT_CORRUPTED_GOTO
References: <4974CA20.6050308@sandeen.net> <20090120004611.GA6445@disturbed> <20090120112910.GA6831@infradead.org> <4975B9C4.7030401@gmail.com> <20090120114906.GA12526@infradead.org> <20090120121335.GA19182@infradead.org> <20090120124515.GA31838@infradead.org> <4975D88B.7020906@gmail.com> <20090120140514.GA2976@infradead.org> <4975DE45.7050004@gmail.com> <20090121040512.GK10158@disturbed>
In-Reply-To: <20090121040512.GK10158@disturbed>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner pisze:
> On Tue, Jan 20, 2009 at 03:23:01PM +0100, Jacek Luczak wrote:
>> Christoph Hellwig pisze:
>>> On Tue, Jan 20, 2009 at 02:58:35PM +0100, Jacek Luczak wrote:
>>>> Good job! Is there some ,,quick'' fix?
>>> The patch below makes it go away for me, alternatively just enable
>>> CONFIG_LBD.
>>>
>>>
>>> Index: linux-2.6/fs/xfs/xfs_types.h
>>> ===================================================================
>>> --- linux-2.6.orig/fs/xfs/xfs_types.h	2009-01-20 14:55:55.806068213 +0100
>>> +++ linux-2.6/fs/xfs/xfs_types.h	2009-01-20 14:56:01.437945154 +0100
>>> @@ -96,7 +96,7 @@ typedef	__uint64_t	xfs_dfilblks_t;	/* nu
>>>  /*
>>>   * Memory based types are conditional.
>>>   */
>>> -#if XFS_BIG_BLKNOS
>>> +#if 1 //XFS_BIG_BLKNOS
>>>  typedef	__uint64_t	xfs_fsblock_t;	/* blockno in filesystem (agno|agbno) */
>>>  typedef __uint64_t	xfs_rfsblock_t;	/* blockno in filesystem (raw) */
>>>  typedef __uint64_t	xfs_rtblock_t;	/* extent (block) in realtime area */
>>>
>> I've applied it and now running ,,fixed'' kernel. What I've notice is:
>> $ LC_ALL=C df -h
>> Filesystem            Size  Used Avail Use% Mounted on
>> /dev/sda1              20G  -40E   40E   -  /
>> /dev/sda5              20G  -23E   23E   -  /home
>> /dev/sda6              56G   56G  774M  99% /NORA
>> /dev/sda7              45G   44G  1.2G  98% /MAGAZYN
> 
> Please try the patch I posted this morning - it fixes the problem
> properly and shouldn't have this side effect.
> 

Your patch work for me. I've made also some tests a'la one proposed by
Christoph, here also everything works. Good work guys!

Have a nice day,

-Jacek
