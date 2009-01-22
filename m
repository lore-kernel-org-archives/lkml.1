Return-Path: <linux-kernel-owner+w=401wt.eu-S1759420AbZAVW4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759420AbZAVW4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 17:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756039AbZAVW4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 17:56:00 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:33942 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbZAVWz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 17:55:59 -0500
Message-ID: <4978F968.7010108@oracle.com>
Date: Thu, 22 Jan 2009 14:55:36 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for January 22 (staging/android)
References: <20090122180543.1ab0baa6.sfr@canb.auug.org.au> <4978A9D0.2050103@oracle.com> <20090122221849.GA30477@suse.de>
In-Reply-To: <20090122221849.GA30477@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010208.4978F974.000F:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Jan 22, 2009 at 09:16:00AM -0800, Randy Dunlap wrote:
>> Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Changes since 20090121:
>> drivers/staging/android/timed_gpio.c: In function 'gpio_enable_show':
>> drivers/staging/android/timed_gpio.c:52: error: 'ktime_t' has no member named 'tv'
>> drivers/staging/android/timed_gpio.c:52: error: 'ktime_t' has no member named 'tv'
> 
> Is this due to a change in -next?  I see 'tv' as a valid field in
> kime_t in Linus's tree.
> 
> confused,
> 
> greg k-h


'tv' is a union name, not a field name, right?


http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=include/linux/ktime.h;h=ce5983225be4e6430cadbff9cc5cbf448a66e647;hb=HEAD :


 46 union ktime {
47         s64     tv64;
48 #if BITS_PER_LONG != 64 && !defined(CONFIG_KTIME_SCALAR)
49         struct {
50 # ifdef __BIG_ENDIAN
51         s32     sec, nsec;
52 # else
53         s32     nsec, sec;
54 # endif
55         } tv;
56 #endif
57 };
58
59 typedef union ktime ktime_t;            /* Kill this */
