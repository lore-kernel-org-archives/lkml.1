Return-Path: <linux-kernel-owner+w=401wt.eu-S1765352AbXFRTOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765352AbXFRTOn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 15:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762714AbXFRTOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 15:14:35 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:53528 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762015AbXFRTOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 15:14:34 -0400
Message-ID: <4676D97E.4000403@dgreaves.com>
Date: Mon, 18 Jun 2007 20:14:06 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070601)
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
Cc: David Robinson <zxvdr.au@gmail.com>,
       LVM general discussion and development 
	<linux-lvm@redhat.com>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com, linux-pm <linux-pm@lists.osdl.org>,
       LinuxRaid <linux-raid@vger.kernel.org>
Subject: Re: [linux-lvm] 2.6.22-rc4 XFS fails after hibernate/resume
References: <46744065.6060605@dgreaves.com> <4674645F.5000906@gmail.com> <46751D37.5020608@dgreaves.com> <4676390E.6010202@dgreaves.com> <20070618145007.GE85884050@sgi.com>
In-Reply-To: <20070618145007.GE85884050@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

OK, just an quick ack

When I resumed tonight (having done a freeze/thaw over the suspend) some libata 
errors threw up during the resume and there was an eventual hard hang. Maybe I 
spoke to soon?

I'm going to have to do some more testing...

David Chinner wrote:
> On Mon, Jun 18, 2007 at 08:49:34AM +0100, David Greaves wrote:
>> David Greaves wrote:
>> So doing:
>> xfs_freeze -f /scratch
>> sync
>> echo platform > /sys/power/disk
>> echo disk > /sys/power/state
>> # resume
>> xfs_freeze -u /scratch
>>
>> Works (for now - more usage testing tonight)
> 
> Verrry interesting.
Good :)


> What you were seeing was an XFS shutdown occurring because the free space
> btree was corrupted. IOWs, the process of suspend/resume has resulted
> in either bad data being written to disk, the correct data not being
> written to disk or the cached block being corrupted in memory.
That's the kind of thing I was suspecting, yes.

> If you run xfs_check on the filesystem after it has shut down after a resume,
> can you tell us if it reports on-disk corruption? Note: do not run xfs_repair
> to check this - it does not check the free space btrees; instead it simply
> rebuilds them from scratch. If xfs_check reports an error, then run xfs_repair
> to fix it up.
OK, I can try this tonight...

> FWIW, I'm on record stating that "sync" is not sufficient to quiesce an XFS
> filesystem for a suspend/resume to work safely and have argued that the only
> safe thing to do is freeze the filesystem before suspend and thaw it after
> resume. This is why I originally asked you to test that with the other problem
> that you reported. Up until this point in time, there's been no evidence to
> prove either side of the argument......
> 
> Cheers,
> 
> Dave.

