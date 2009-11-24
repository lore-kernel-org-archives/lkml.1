Return-Path: <linux-kernel-owner+w=401wt.eu-S933938AbZKXSvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933938AbZKXSvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 13:51:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933864AbZKXSvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 13:51:38 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:39640 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933852AbZKXSvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 13:51:37 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Date: Tue, 24 Nov 2009 11:51:34 -0700
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [patch 0/5] Journal guided resync and support
In-reply-to: <20091124114319.GA1397@ucw.cz>
To: Pavel Machek <pavel@ucw.cz>
Cc: scjody@sun.com, linux-ext4@vger.kernel.org, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-id: <856BC3CD-F483-4899-BCFE-0ACB59CED9BE@sun.com>
X-Mailer: Apple Mail (2.936)
References: <20091119212241.283629302@sun.com> <20091124114319.GA1397@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-11-24, at 04:43, Pavel Machek wrote:
>> This is an updated implementation of journal guided resync,  
>> intended to be suitable for production systems.  This feature  
>> addresses the problem with RAID arrays that take too long to resync  
>> - similar to the existing MD write-intent bitmap feature, we resync  
>> only the stripes that were undergoing writes at the time of the  
>> crash.  Unlike write-intent bitmaps, our testing shows very little  
>> performance degredation as a result of the feature - around 3-5% vs  
>> around 30%
>> for bitmaps.
>
> Good. Now when fs know about raid and wise versa... perhaps it is time
> to journal surrounding data on stripe so that power fails do not
> destroy data on degraded raid5?


That's an interesting idea.  I suspect this could be done more  
efficiently by only journaling the parity block update, but there is  
no way for the journal to address this block.

That said, unfortunately Jody has no more time to work on these  
patches (due to data ordering requirements Lustre can't use them), and  
while they are functionally complete for RHEL5 + ext3, they need to be  
ported to 2.6.current and ext4 by someone or they will die a silent  
death.


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

