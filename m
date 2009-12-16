Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbZLPJow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbZLPJow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 04:44:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018AbZLPJov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 04:44:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbZLPJot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 04:44:49 -0500
Message-ID: <4B28AC09.2000302@redhat.com>
Date: Wed, 16 Dec 2009 10:44:41 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091130 Thunderbird/3.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Alasdair G Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com
Subject: Re: dm: sysfs add empty release function to avoid debug warning
References: <200912151735.nBFHZ8XP018683@hera.kernel.org> <20091216004739.GB4898@kroah.com>
In-Reply-To: <20091216004739.GB4898@kroah.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2009 01:47 AM, Greg KH wrote:
> On Tue, Dec 15, 2009 at 05:35:08PM +0000, James Bottomley wrote:
>> commit: d2bb7df8cac647b92f51fb84ae735771e7adbfa7
>> From: Milan Broz <mbroz@redhat.com>
>> Date: Thu, 10 Dec 2009 23:51:53 +0000
>> Subject: [PATCH] dm: sysfs add empty release function to avoid debug warning
>>
>> This patch just removes an unnecessary warning:
>>  kobject: 'dm': does not have a release() function,
>>  it is broken and must be fixed.
>>
>> The kobject is embedded in mapped device struct, so
>> code does not need to release memory explicitly here.
> 

> Please, this is totally and completly wrong.  And if you feel that it is
> needed, then your design is wrong and it needs to be fixed.

There are several places in kernel, where kobject have not defined release
method. Yes, something is wrong here.
So quietly ignoring warning is ok? Why is not there BUG_ON(!release) then?

The sysfs attributes here just represents attributes of block device object,
this device is always removed before release here is called.

So if there is preferred to do another alloc/free, no problem.

> And note, as per the Documentation/kobject.txt file, you were warned
> about this public mocking, next time it will be harsher.
> 
> Heh, and you tried to get this into a -stable kernel release, as if.

btw I did'n added stable@, someone added that later. But it is not relevant. 

> Patch left below so that others can mock.

Enjoy;-)

Milan
