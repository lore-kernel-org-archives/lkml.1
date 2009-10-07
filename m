Return-Path: <linux-kernel-owner+w=401wt.eu-S1755584AbZJGW4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584AbZJGW4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 18:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754728AbZJGW4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 18:56:36 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:26083 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690AbZJGW4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 18:56:35 -0400
Message-ID: <4ACD1C3D.3030506@oracle.com>
Date: Wed, 07 Oct 2009 15:54:53 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless: make WEXT_SPY and WEXT_PRIV select WEXT_CORE
References: <20091007105720.a2457e5b.randy.dunlap@oracle.com>	 <1254949672-24022-1-git-send-email-linville@tuxdriver.com>	 <4ACD0E5A.7060106@oracle.com> <1254954842.3713.7.camel@johannes.local>
In-Reply-To: <1254954842.3713.7.camel@johannes.local>
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4ACD1C4C.0169:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Berg wrote:
> On Wed, 2009-10-07 at 14:55 -0700, Randy Dunlap wrote:
>> John W. Linville wrote:
>>> Should prevent this build error reported by Randy...
>>>
>>> net/wireless/wext-priv.c:206: error: implicit declaration of function 'call_commit_handler'
>>> make[3]: *** [net/wireless/wext-priv.o] Error 1
>>>
>>> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
>>> Signed-off-by: John W. Linville <linville@tuxdriver.com>
>> Sorry, it did not work for me.
> 
>> linux-next-20091007/net/wireless/wext-priv.c:206: error: implicit declaration of function 'call_commit_handler'
>> make[3]: *** [net/wireless/wext-priv.o] Error 1
>>
>> Drivers like hostap and orinoco (hermes) select WEXT_PRIV regardless
>> of the setting of WEXT_CORE.  oh, and staging/ drivers do that also.
> 
> But they also select WIRELESS_EXT, which should cause WEXT_CORE to be
> turned on. Is it possible that is failing?

# CONFIG_WIRELESS is not set
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y

WEXT_CORE is not enabled.  I haven't found the culprit, but I suspect "select".

but what in WIRELESS_EXT would also cause WEXT_CORE to be enabled?

~Randy
