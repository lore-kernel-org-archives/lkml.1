Return-Path: <linux-kernel-owner+w=401wt.eu-S1761051AbZATKl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761051AbZATKl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 05:41:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756068AbZATKlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 05:41:46 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:27489 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760857AbZATKlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 05:41:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=N7N+gVDZgUWEBIKmbRgK9XWodoLebuuuR6qMAY9clHnhkwGmO8KhdspWGc6P+i+0T2
         GpTUcg1w7r4qdZz3CCwInmnuYXZKzb2zl9MUuD4DgsQYIt5th9PiOrBS3196fzJyHmB4
         bPeFmVtDRcyaul7rzZlLbxBifnxKyf+WNSYzg=
Message-ID: <4975AAAF.4040804@gmail.com>
Date: Tue, 20 Jan 2009 11:42:55 +0100
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: Eric Sandeen <sandeen@sandeen.net>
CC: LKML <linux-kernel@vger.kernel.org>, hch@infradead.org,
       xfs mailing list <xfs@oss.sgi.com>
Subject: Re: [XFS] 2.6.29-rc2: XFS internal error XFS_WANT_CORRUPTED_GOTO
References: <497468C1.3000001@gmail.com> <4974CA20.6050308@sandeen.net> <49759844.5080405@gmail.com>
In-Reply-To: <49759844.5080405@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jacek Luczak pisze:
> Eric Sandeen pisze:
>> Jacek Luczak wrote:
>>> Hi All,
>>>
>>> I've stepped into XFS issue/bug. Yesterday I've compiled 2.6.29-rc2 and no
>>> didn't found errors. Today I've booted my notebook and XFS bug have occurred.
>>> System reboot didn't helped, same error appeared.
>>>
>>> Some info:
>>> [1] config: http://pin.if.uz.zgora.pl/~difrost/linux-next/2.6.29-rc2.config
>>> [2] kernel logs:
>>> http://pin.if.uz.zgora.pl/~difrost/linux-next/2.6.29-rc2_XFS-bug.log
>>> [3] most interesting part of log below.
>> so this happens every mount?  Reproducible is good.  How large is the
>> filesystem (too large to extract elsewhere for analysis...?) (plus I
>> suppose it'll be hard to get to it when you can't even boot....)
>>
>> -Eric
>>
> 
> Hi Eric,
> 
> funny or sad thing is that this happens while mounting only one of partitions
> (/home) which is:
> $ df -h | grep /home
> /dev/sda5              20G   14G  6,0G  69% /home
> 
> This bug is quite strange, as I mentioned, first boot on new kernel went OK,
> next two resulted in such behavior. Now I'm running 2.6.29-rc2-12097-gf3b8436
> and no bug here. Nevertheless I'm not fully happy, as it was seen before, the
> bug might still happen (will boot few times to test it and report back to you).
> 
> First yesterday buggy but went unnoticed so I've started fluxbox and firefox
> (errors seen in log), as usual, then found that sth is wrong. Second boot was
> also buggy than I've returned to old kernel where everything was OK ... nearly
> everything, cause firefox suddenly ,,forgot'' all configuration.
> 
> I will boot my notebook on all those 2.6.29-* kernel few times and maybe be able
> to reproduce that bug.
> 

I've made some tests. Basically umount + mount (with time measurement):

$ for i in $(seq -s ' ' 1 20) ; do echo "[=> umount [$MNT]: $i" ; time umount
$MNT ; [ $? -eq 0 ] && echo "[=> mount [$MNT]: $i" && time mount $MNT || break ;
done 2>&1 | tee ~/${MNT##*/}_mount_git.log

where MNT was set to three different partitions (all with XFS). Both on rc2 and
git version, no bug appeared. If someone is interested (I've seen some delays in
mounting before), some time results here:
http://pin.if.uz.zgora.pl/~difrost/linux-next/mount_logs/

I will still mess around so maybe it will appear once more than will try do some
more tests (suggestions are welcome).

-Jacek
