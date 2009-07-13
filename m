Return-Path: <linux-kernel-owner+w=401wt.eu-S1757201AbZGMUrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbZGMUrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 16:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757175AbZGMUrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 16:47:22 -0400
Received: from mail.tpi.com ([70.99.223.143]:2439 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757160AbZGMUrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 16:47:21 -0400
Message-ID: <4A5B9D56.1030308@tpi.com>
Date: Mon, 13 Jul 2009 14:47:18 -0600
From: Tim Gardner <timg@tpi.com>
Reply-To: timg@tpi.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090710)
MIME-Version: 1.0
To: reinette chatre <reinette.chatre@intel.com>
CC: "Zhu, Yi" <yi.zhu@intel.com>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] iwlwifi 3945: Fix IWL_SCAN compile error
References: <20090713190803.9A70BF8D2C@sepang.rtg.net>	 <1247515401.17896.1630.camel@rc-desk>  <4A5B9388.4030208@tpi.com> <1247516054.17896.1634.camel@rc-desk>
In-Reply-To: <1247516054.17896.1634.camel@rc-desk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reinette chatre wrote:
> Hi Tim,
> 
> On Mon, 2009-07-13 at 13:05 -0700, Tim Gardner wrote:
>> reinette chatre wrote:
>>> Hi Tim,
>>>
>>> On Mon, 2009-07-13 at 12:08 -0700, Tim Gardner wrote:
>>>> From 2c7c806570ad72f5af2e778f2fe71aae7d727e02 Mon Sep 17 00:00:00 2001
>>>> From: Tim Gardner <tim.gardner@canonical.com>
>>>> Date: Mon, 13 Jul 2009 12:53:32 -0600
>>>> Subject: [PATCH] iwlwifi 3945: Fix IWL_DEBUG_SCAN compile
>>>>
>>>> Added a missing parameter in the macro invocation to correct a
>>>> compile error when CONFIG_IWLWIFI_DEBUG is enabled.
>>>>
>>>> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
>>>> ---
>>>>  drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
>>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
>>>> index 2564288..67332fb 100644
>>>> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
>>>> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
>>>> @@ -2962,7 +2962,7 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
>>>>  	}
>>>>  
>>>>  	if (scan->channel_count == 0) {
>>>> -		IWL_DEBUG_SCAN("channel count %d\n", scan->channel_count);
>>>> +		IWL_DEBUG_SCAN(priv,"channel count %d\n", scan->channel_count);
>>>>  		goto done;
>>>>  	}
>>>>  
>>> On which code did you base this patch?
>>>
>>> Reinette
>>>
>>>
>> Head of Linus' tree, but I see that its already fixed in
>> wireless-testing. I guess I pulled the trigger too soon.
> 
> I just pulled the latest from Linus but cannot see this problem. We also
> do not have anything related to this pending for 2.6.31.
> 
> Reinette
> 
> 

You are correct. It appears I've got a rebase issue. I rebased Ubuntu
Karmic against linus git 4a390e07fc53ce9dd615d7b788e9ecc73f87ad94 and
find that  there is one extra commit when comparing the output of 'git
log --pretty=oneline drivers/net/wireless/iwlwifi/iwl3945-base.c' . The
last commit that touches iwl3945-base.c in the Karmic tree is 'iwl3945:
do not send scan command if channel count zero', which is totally
bizarre. If I look at the patches created by 'git log -p
drivers/net/wireless/iwlwifi/iwl3945-base.c', the patch that implements
'iwl3945: do not send scan command if channel count zero' is duplicated.
How can that be? Guess I'll keep digging.

rtg
-- 
Tim Gardner timg@tpi.com www.tpi.com
OR 503-601-0234 x102 MT 406-443-5357
