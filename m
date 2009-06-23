Return-Path: <linux-kernel-owner+w=401wt.eu-S1759384AbZFWPBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384AbZFWPBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758529AbZFWPBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:01:13 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:50127 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758788AbZFWPBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:01:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=WkwGVr7Ox6ThbzKU3s2yJqgYjzIbL8IY1eLlR8KC04jHAwb5XA0hXpUAIGNyWwyeJd
         +0QLd0kpsLWOsaGazSITw0WmzrrKGnZXWRELy9Y6vvUDGaOWdeuIjB3mYPSKHiPp1HDd
         sTCLqBLRUDyK9ygUvteQeueOmKt7deqZ685v8=
MIME-Version: 1.0
In-Reply-To: <20090610210247.GC1381@ucw.cz>
References: <4A280BD4.9080908@canonical.com> <20090610210247.GC1381@ucw.cz>
Date: Tue, 23 Jun 2009 17:01:14 +0200
X-Google-Sender-Auth: 652f0dd463482874
Message-ID: <5201e28f0906230801s11723e1bj61ac7560bfbbe55c@mail.gmail.com>
Subject: Re: [PATCH] mmc: prevent dangling block device from accessing stale 
	queues
From: Stefan Bader <stefan.bader@canonical.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, pierre@ossman.eu,
       linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I did not see any news related to this issue. Pierre, are you waiting
on more info from my side? Or did I miss a change somewhere else?

Stefan


> On Thu 2009-06-04 20:00:52, Stefan Bader wrote:
>> Kernel: 2.6.30-rc7 based
>> Worked in 2.6.28 (probably only because things went at a different speed)
>>
>> Testcase: Use ext3/ext4 on a SD card partitioned with one primary DOS
>> partition and leave it mounted while suspend/resume.
>>
>> Result: After resume the partition table of the SD card has been erased.
>>
>> The detailed description can be found at:
>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/383668
>>
>> In essence the mmc block device frees the generic request queue before
>> the last user of the gendisk has stopped using it leaving an invalid
>> queue pointer which get unfortunately re-used before more requests come
>> in for the old device.
>>
>> The bugfix will cause more I/O error messages and might not be the
>> ultimate way things should work, but it prevents data from getting lost.
>
