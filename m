Return-Path: <linux-kernel-owner+w=401wt.eu-S1755375AbXFNTBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbXFNTBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 15:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbXFNTBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 15:01:04 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:25621 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752770AbXFNTBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 15:01:03 -0400
Message-ID: <4671907F.5050706@cfl.rr.com>
Date: Thu, 14 Jun 2007 15:01:19 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Mark Lord <lkml@rtr.ca>, Andrew Morton <akpm@linux-foundation.org>,
       Stephen Tweedie <sct@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ext3fs: umount+sync not enough to guarantee metadata-on-disk
References: <46680BB8.50404@rtr.ca> <20070607084142.42583639.akpm@linux-foundation.org> <46682BE7.6080802@rtr.ca> <20070610182746.GA4272@ucw.cz>
In-Reply-To: <20070610182746.GA4272@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jun 2007 19:01:12.0806 (UTC) FILETIME=[60680860:01C7AEB6]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15238.000
X-TM-AS-Result: No--9.682900-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>>> Did this succeed?  If the application is still 
>>> truncating that file, the
>>> umount should have failed.
>> Actually, what I expect to happen is for the remount,ro
>> to block  until the file deletion completes.  But it 
>> doesn't.
>>
>> Once a f/s is read-only, there should be NO writing to 
>> it.  Right?
> 
> Linux happily writes to filesystems mounted read-only. It will replay
> journal on them.

That's a bug and needs fixed.  Read only means read _only_.

And the question still remains; why is sync() not blocking until the 
file has been completely unlinked and the disk is consistent?
