Return-Path: <linux-kernel-owner+w=401wt.eu-S1753086AbXJBHEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbXJBHEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 03:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751134AbXJBHEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 03:04:44 -0400
Received: from toronto053.server4you.de ([62.75.220.53]:40064 "EHLO
	toronto053.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbXJBHEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 03:04:43 -0400
X-Greylist: delayed 1151 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Oct 2007 03:04:43 EDT
Message-ID: <4701E902.3070104@monom.org>
Date: Tue, 02 Oct 2007 08:45:22 +0200
From: Daniel Wagner <wagi@monom.org>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: =?UTF-8?B?S3Jpc3RpYW4gSMO4Z3NiZXJn?= <krh@bitplanet.net>
CC: Pieter Palmers <pieterp@joow.be>,
       =?UTF-8?B?S3Jpc3RpYW4gSMO4Z3NiZXJn?= <krh@redhat.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: adopt read cycle timer ABI from raw1394
References: <tkrat.9b780b2f580f1733@s5r6.in-berlin.de>	<tkrat.4aa1f1b5ce7df936@s5r6.in-berlin.de> <4700BE87.2040107@joow.be> <59ad55d30710010903y76330624ka45747c0b5983cfd@mail.gmail.com>
In-Reply-To: <59ad55d30710010903y76330624ka45747c0b5983cfd@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Pieter, do applications like yours need the cycle counter only for a few
>>> predetermined packets or for each and every packet?
>> We need it for every packet for two reasons:
>> 1) it's the only way to determine how many packets were dropped when
>> packet drops are flagged in the callback
> 
> Your application should know what the timestamp should be for each iso
> receive callback and if you see a larger value than expected you can
> use that to calculate how many cycles were lost.

That might not work if the device is synchronized to SPDIF for example. 
In this case it is possible (and very likely) that the two clock domains 
(SPDIF and the firewire bus) drift. The time difference between two 
timestamps do not have to be the same all the time. So it can be hard 
(possible?) to predict the next timestamp correctly.

daniel
