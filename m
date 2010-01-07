Return-Path: <linux-kernel-owner+w=401wt.eu-S1753068Ab0AGUdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068Ab0AGUdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 15:33:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007Ab0AGUde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 15:33:34 -0500
Received: from er-systems.de ([85.25.136.202]:43274 "EHLO er-systems.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752980Ab0AGUdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 15:33:32 -0500
Date: Thu, 7 Jan 2010 21:33:29 +0100 (CET)
From: Thomas Voegtle <tv@lio96.de>
To: Greg KH <gregkh@suse.de>
cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org, dmonakhov@openvz.org
Subject: Re: Linux 2.6.31.10
In-Reply-To: <20100107194131.GA22983@suse.de>
Message-ID: <alpine.LNX.2.00.1001072125040.26784@er-systems.de>
References: <20100106234533.GC1960@kroah.com> <alpine.LNX.2.00.1001071522480.5426@er-systems.de> <20100107180449.GA17495@suse.de> <alpine.LNX.2.00.1001072033301.26784@er-systems.de> <20100107194131.GA22983@suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Virus-Checker-Version: clamassassin 1.2.4 with clamdscan / ClamAV 0.95.3/10267/Thu Jan  7 03:04:56 2010 signatures .
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jan 2010, Greg KH wrote:

> On Thu, Jan 07, 2010 at 08:36:07PM +0100, Thomas Voegtle wrote:
>> On Thu, 7 Jan 2010, Greg KH wrote:
>>
>>> On Thu, Jan 07, 2010 at 03:27:21PM +0100, Thomas Voegtle wrote:
>>>> Hi,
>>>>
>>>> On Wed, 6 Jan 2010, Greg KH wrote:
>>>>> I'm announcing the release of the 2.6.31.10 kernel.  All users of the
>>>>> 2.6.31 kernel series are very strongly encouraged to upgrade.
>>>>
>>>>
>>>> Something broken here, during using a suse 11.2 installation with quota
>>>> switched on (this is reproducible )
>>>
>>> Jan, this looks like something in the quota patches you sent.  Any
>>> ideas?
>>>
>>> Thomas, is this on an ext3 or ext4 partition, or something else?
>>
>>
>> The one with quota enabled was an ext3 partition, mounted on /
>
> Thanks.
>
> Could you run 'git bisect' between the two kernel versions to try to
> track the problem down to the single patch?

Done, between 2.6.31.9 and 2.6.31.11


c169e13a6662cbf36fc0098508e7aa31b49cbf23 is first bad commit
commit c169e13a6662cbf36fc0098508e7aa31b49cbf23
Author: Dmitry Monakhov <dmonakhov@openvz.org>
Date:   Mon Dec 14 15:21:13 2009 +0300

     quota: decouple fs reserved space from quota reservation

     commit fd8fbfc1709822bd94247c5b2ab15a5f5041e103 upstream.



Reverting that patch on top of 2.6.31.11 fixes the problem for me.

