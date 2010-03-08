Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab0CHUss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 15:48:48 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43820 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362Ab0CHUsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 15:48:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=HzB6FHFBkgyFpAH567St7J1mpjSlR4pgh2Kd6RsmtiG1527fuF5JoyI1P+dKJWSCWI
         Yo42tlDfldNLOK5KnHQFV9AZ2xMEsj7AxiUJzSwWKbTB4A/vQ8u9mYqXsU483S01xS4o
         Fn36X/hvWIE0V0uaDI6qYma79KlER0LPfiRO8=
Message-ID: <4B9562A1.2020205@gmail.com>
Date: Mon, 08 Mar 2010 15:48:33 -0500
From: jim owens <owens6336@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: David Newall <davidn@davidnewall.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Jeff Garzik <jeff@garzik.org>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: defrag deployment status (was Re: [PATCH] ext4: allow defrag
 (EXT4_IOC_MOVE_EXT) in 32bit compat mode)
References: <201003072132.10579.borntraeger@de.ibm.com> <4B94367E.9080506@garzik.org> <201003080853.42978.borntraeger@de.ibm.com> <4B9518DA.8010201@davidnewall.com>            <4B952437.8020607@gmail.com> <4987.1268077130@localhost>
In-Reply-To: <4987.1268077130@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Mon, 08 Mar 2010 11:22:15 EST, jim owens said:
> 
>> No.  Your logic would be correct if rotating disks had
>> similar speed at all locations.  Current disks are much
>> faster at the 0 end than at the middle or highest address.
>>
>> It is not unusual to see 2x difference in transfer speed
>> so you always want the important stuff as low as possible.
> 
> On the flip side, seek time is so much larger than the time spent
> actually reading that minimizing the seeks will improve total throughput
> more.  Sure, maybe you spend 0.05ms reading instead of 0.1ms - but if
> the seek took 0.75ms rather than 0.5ms you're still in the hole.

Agree that seek proximity is important, but seeking at the low end
for N blocks is also faster than seeking the same N blocks at the
slow high end of the disk. 

So my point is you want to pack the data together when you can
at the low address end of the disk to maximize performance.
And we should include some free space in the fast zone because
much of our performance involves short-lived writes.

If you are filling and accessing all of the disk, then maybe
"pack from the middle" will average out better, but we hope
most filesystems have a small hot subset.  If you are often
accessing outside the hot zone a lot then you probably will
get end-to-end seek penalties anyway if you are defragging
to an "old, free, hot, free, old" layout.

jim 
