Return-Path: <linux-kernel-owner+w=401wt.eu-S1422689AbXCBBah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422689AbXCBBah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 20:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422692AbXCBBag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 20:30:36 -0500
Received: from mailx.hitachi.co.jp ([133.145.228.49]:59778 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422689AbXCBBaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 20:30:35 -0500
Message-ID: <45E77D41.1080408@hitachi.com>
Date: Fri, 02 Mar 2007 10:26:25 +0900
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, miklos@szeredi.hu,
       yumiko.sugita.yf@hitachi.com, masami.hiramatsu.pt@hitachi.com,
       hidehiro.kawai.ez@hitachi.com, yuji.kakutani.uw@hitachi.com,
       soshima@redhat.com, haoki@redhat.com, nikita@clusterfs.com
Subject: Re: [RFC][PATCH 0/3] VM throttling: avoid blocking occasional writers
References: <45DED819.9040404@hitachi.com>	<20070224134646.0f4edeae.kamezawa.hiroyu@jp.fujitsu.com>	<45E38048.3020705@hitachi.com> <20070227103952.4fc236bd.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070227103952.4fc236bd.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kamezawa-san,

KAMEZAWA Hiroyuki wrote:
>>> >>> Interesting, but how about adjust this parameter like below instead of
>>> >>> adding new control knob ?(this kind of knob is not easy to use.)
<snip>
>>> >>> count_dirty_pages_on_device_limited(bdi, writechunk) above returns
>>> >>> dirty pages on bdi. if # of dirty_pages on bdi is larger than writechunk,
>>> >>> just returns writechunk.
>> >>
>> >> I think that way is not enough to control the total amount of
>> >> Dirty+Writeback.
>> >>
>> >> In that way, while writeback_inodes() scans for dirty pages and writes
>> >> them back, the caller will be blocked only if the length of the write-
>> >> requests queue is longer than nr_requests.

> > What nr_request means ?

nr_requests is a parameter that means upper limit of the length of I/O
(read- and write-)requests queue of the device, which is configurable
from /sys/block/<device>/queue/nr_requests. A process, which perform I/O
when there are more than nr_requests requests in the queue, will be blocked.

> > But Ok, maybe I'm not understanding. What I want to ask you is do
> > per-device-write-throttling rather than adding a new parameter.

In the patchset, per-device-write-throttling is done by the behavior
of the write-requests queue described above.

When the queue of the disk becomes full while writeback of Dirty in
writeback_inodes(), heavy writes to the disk will be blocked.
In contrast, if it's so occasional that the queue doesn't become full,
writes will not be blocked.


Regards
--
Tomoki Sekiyama
Hitachi, Ltd., Systems Development Laboratory
