Return-Path: <linux-kernel-owner+w=401wt.eu-S1755559AbZITSqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbZITSqb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 14:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755081AbZITSq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 14:46:28 -0400
Received: from mail-yw0-f173.google.com ([209.85.211.173]:44267 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbZITSq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 14:46:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=gR/WaU1uEf4qf5q/VIAzDYUjGz7p7Mowrozs/yHl9SmYslNrZznC9z+iAGL/S02lCw
         2Ws1Tw3QqfXXTPtVoOKNETbYNjTPSK0zzed25zS5XLN6H1koIjj5rMgknEykdkuZUWAm
         +R/sJjvtWBphU5UjJsVO7JlGLCtvHkaUFiY9g=
Message-ID: <4AB67883.3010500@gmail.com>
Date: Sun, 20 Sep 2009 12:46:27 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Chris Webb <chris@arachsys.com>, Neil Brown <neilb@suse.de>,
       Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>,
       Mark Lord <mlord@pobox.com>
Subject: Re: MD/RAID time out writing superblock
References: <20090917115728.GA13854@arachsys.com> <4AB2596D.10809@kernel.org>
In-Reply-To: <4AB2596D.10809@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2009 09:44 AM, Tejun Heo wrote:
>> Thanks Neil. This implies that when we see these fifteen second
>> hangs reading /proc/mdstat without write errors, there are genuinely
>> successful superblock writes which are taking fifteen seconds to
>> complete, presumably corresponding to flushes which complete but
>> take a full 15s to do so.
>>
>> Would such very slow (but ultimately successful) flushes be
>> consistent with the theory of power supply issues affecting the
>> drives? It feels like the 30s timeouts on flush could be just a more
>> severe version of the 15s very slow flushes.
>
> Probably not.  Power problems usually don't resolve themselves with
> longer timeout.  If the drive genuinely takes longer than 30s to
> flush, it would be very interesting tho.  That's something people have
> been worrying about but hasn't materialized yet.  The timeout is
> controlled by SD_TIMEOUT in drivers/scsi/sd.h.  You might want to bump
> it up to, say, 60s and see whether anything changes.

It's possible if the power dip only slightly disrupted the drive it 
might just take longer to complete the write. I've also seen reports of 
vibration issues causing problems in RAID arrays (there's a video on 
Youtube of a guy yelling at a Sun disk array during heavy I/O and the 
resulting vibrations causing an immediate spike in I/O service times). 
Could be something like that causing issues with simultaneous media 
access to all drives in the array, too..
