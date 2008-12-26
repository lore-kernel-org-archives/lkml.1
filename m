Return-Path: <linux-kernel-owner+w=401wt.eu-S1754382AbYLZJpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382AbYLZJpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 04:45:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753673AbYLZJpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 04:45:42 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:39064 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661AbYLZJpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 04:45:41 -0500
X-AuditID: 0ac90650-aacfcba000004120-42-4954a7c33444
Message-ID: <4954A7BE.6080204@hitachi.com>
Date: Fri, 26 Dec 2008 18:45:34 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       yumiko.sugita.yf@hitachi.com, satoshi.oshima.fk@hitachi.com
Subject: Re: [PATCH] coredump_filter: enable to change the default filter
References: <20081219195311.81C4AFC351@magilla.sf.frob.com> 
    <49547836.7040907@hitachi.com> 
    <20081226153931.5CBB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20081226153931.5CBB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:

>>>>However, we would need a special care for PID namespace if we use
>>>>init's coredump_filter as default.  For a process with new PID
>>>>namespace and new /proc, writing to /proc/1/coredump_filter doesn't
>>>>mean changing default, although it's not a usual operation.
>>>
>>>I'd figured that private PID namespaces with their own init would want
>>>their own private settings for this default too.
>>
>>Probably it's true, but I'm not sure if having coredump_filter have
>>two means is acceptable.  init in a private PID namespace can die
>>and dump a core file.  So its coredump_filter has two means; default
>>setting for the namespace and setting for itself.  
> 
> FWIW, I think private namespace should have private settings framework.
> I don't like to make special private settings code in this patch.
> 
> Yeah, defenitely we need to private settings for various reason, I agreed.
> but we also need consistent private settings rule and framework.
> otherwise, we will make various non consistent crap. maybe..

Anyway, as Andrew pointed out, current coredump filter doesn't
care for user mode helpers.  So we need some sort of changes in
coredump filter so that users can change user mode helpers'
settings; use child_reapers setting as default (Roland's
suggestion) or use a boot parameter.

Thanks,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center

