Return-Path: <linux-kernel-owner+w=401wt.eu-S1756266AbYFRW2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266AbYFRW2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 18:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960AbYFRW2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 18:28:16 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:62716 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbYFRW2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 18:28:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=l889cx9ZV9cyt+ZPfflteBn6Wl0qpeoTeWxHKUdua136u+n/kJ/6bzykSE2Wo+d8cw
         vb7d63eGByqVuZ4Xp0HmWBElwsFOOkAkbiuW1u2PmECoN8vj4ecSYEd2v6GKDsgQ5U6A
         zRWd9lxWdYdzlzoMilXpcss3GNIpk3j8ofGjU=
Message-ID: <48598BFB.1040305@gmail.com>
Date: Thu, 19 Jun 2008 00:28:11 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Swiftdove 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Carl Henrik Lunde <chlunde@ping.uio.no>
CC: balbir@linux.vnet.ibm.com, menage@google.com, matt@bluehost.com,
       roberto@unbit.it, randy.dunlap@oracle.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] i/o bandwidth controller documentation
References: <> <1212791250-32320-2-git-send-email-righi.andrea@gmail.com> <ed038eb20806180816w5a4f9d6bt276dec1373758e08@mail.gmail.com>
In-Reply-To: <ed038eb20806180816w5a4f9d6bt276dec1373758e08@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Carl Henrik Lunde wrote:
> On Sat, Jun 7, 2008 at 00:27, Andrea Righi <righi.andrea@gmail.com> wrote:
> [...]
>> +3. Advantages of providing this feature
>> +
>> +* Allow QoS for block device I/O among different cgroups
> 
> I'm not sure if this can be called QoS, as it does not guarantee
> anything but throttling?

That's correct. There's nothing to guarantee minimum bandwidth levels
right now, the "QoS" is implemented only slowing down i/o "traffic" that
exceeds the limits (probably "i/o traffic shaping" is a better wording).

Minimum thresholds are supposed to be guaranteed if the user configures
a proper i/o bandwidth partitioning of the block devices shared among
the different cgroups (that could mean: the sum of all the single limits
for a device doesn't exceed the total i/o bandwidth of that device... at
least theoretically).

I'll try to clarify better this concept in the documentation that I'll
include in the next patchset version.

I'd also like to explore the io-throttle controller on-top-of other i/o
band controlling solutions (see for example:
http://lkml.org/lkml/2008/4/3/45), in order to exploit both the limiting
feature from io-throttle and use priority / fair queueing alghorithms to
guarantee minimum performance levels.

>> +* The bandwidth limitations are guaranteed both for synchronous and
>> +  asynchronous operations, even the I/O passing through the page cache or
>> +  buffers and not only direct I/O (see below for details)
> 
> The throttling does not seem to cover the I/O path for XFS?
> I was unable to throttle processes reading from an XFS file system.

mmmh... works for me. Are you sure you've limited the correct block
device?

> Also I think the name of the function cgroup_io_account is a bit too innocent?
> It sounds like a inline function "{ io += bytes; }", not like
> something which may sleep.

Agree. What about cgroup_acct_and_throttle_io()? suggestions?

Thanks,
-Andrea
