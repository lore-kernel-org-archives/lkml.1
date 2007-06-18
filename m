Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbXFRHtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbXFRHtt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 03:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbXFRHtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 03:49:39 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:37026 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbXFRHti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 03:49:38 -0400
Message-ID: <4676390E.6010202@dgreaves.com>
Date: Mon, 18 Jun 2007 08:49:34 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070601)
MIME-Version: 1.0
To: David Robinson <zxvdr.au@gmail.com>
Cc: LVM general discussion and development <linux-lvm@redhat.com>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com, linux-pm <linux-pm@lists.osdl.org>,
       LinuxRaid <linux-raid@vger.kernel.org>
Subject: Re: [linux-lvm] 2.6.22-rc4 XFS fails after hibernate/resume
References: <46744065.6060605@dgreaves.com> <4674645F.5000906@gmail.com> <46751D37.5020608@dgreaves.com>
In-Reply-To: <46751D37.5020608@dgreaves.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Greaves wrote:
> David Robinson wrote:
>> David Greaves wrote:
>>> This isn't a regression.
>>>
>>> I was seeing these problems on 2.6.21 (but 22 was in -rc so I waited 
>>> to try it).
>>> I tried 2.6.22-rc4 (with Tejun's patches) to see if it had improved - 
>>> no.
>>>
>>> Note this is a different (desktop) machine to that involved my recent 
>>> bugs.
>>>
>>> The machine will work for days (continually powered up) without a 
>>> problem and then exhibits a filesystem failure within minutes of a 
>>> resume.

<snip>

> OK, that gave me an idea.
> 
> Freeze the filesystem
> md5sum the lvm
> hibernate
> resume
> md5sum the lvm
<snip>
> So the lvm and below looks OK...
> 
> I'll see how it behaves now the filesystem has been frozen/thawed over 
> the hibernate...


And it appears to behave well. (A few hours compile/clean cycling kernel builds 
on that filesystem were OK).


Historically I've done:
sync
echo platform > /sys/power/disk
echo disk > /sys/power/state
# resume

and had filesystem corruption (only on this machine, my other hibernating xfs 
machines don't have this problem)

So doing:
xfs_freeze -f /scratch
sync
echo platform > /sys/power/disk
echo disk > /sys/power/state
# resume
xfs_freeze -u /scratch

Works (for now - more usage testing tonight)

David
