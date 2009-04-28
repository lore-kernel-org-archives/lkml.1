Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488AbZD1U6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbZD1U6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 16:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbZD1U6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 16:58:42 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:34756 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbZD1U6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 16:58:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Dx944hjNEghyQ/qE1/iPSRaORNriuOdZj369dFFSCGdIwHVVHK5F0wOigPmgCeOb9e
         TD4JUu9JPdJ0BzhcCCfwJtOPNPsz3uzXU34RoguAG3iaKbTdM25I68YLyGj7u/fa9UXH
         RUMqNV3ZdoMbMcVa1dihM43zfjFHtL0jFQBtU=
Message-ID: <49F76DF2.5070704@gmail.com>
Date: Tue, 28 Apr 2009 22:58:26 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090310)
MIME-Version: 1.0
To: reinette chatre <reinette.chatre@intel.com>
CC: "linux.kernel" <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 2.6.30-rc3: iwlagn probe timeouts (regression)
References: <49F4F5B1.4020201@gmail.com> <1240852777.29221.6.camel@rc-desk>
In-Reply-To: <1240852777.29221.6.camel@rc-desk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2009 07:19 PM, reinette chatre wrote:
> Hi Niel,
>
> On Sun, 2009-04-26 at 17:00 -0700, Niel Lambrechts wrote:
>   
>> Hi,
>>
>> In earlier 2.6.30 (rc1 and 2) kernel tests I suffered the "beacon loss,
>> sending probe request" problem, during which my connection would
>> intermittently fail and reconnect. With the latest git kernel which
>> seems to include a patch (ad935687dbe7307f5abd9e3f610a965a287324a9) for
>> at least some of this, my card (Intel 5300AGN REV=0x24) completely fails
>> to associate and I get:
>>
>> Apr 27 01:32:36 linux-7vph kernel: Registered led device: iwl-phy0::radio
>> Apr 27 01:32:36 linux-7vph kernel: Registered led device: iwl-phy0::assoc
>> Apr 27 01:32:36 linux-7vph kernel: Registered led device: iwl-phy0::RX
>> Apr 27 01:32:36 linux-7vph kernel: Registered led device: iwl-phy0::TX
>> Apr 27 01:32:36 linux-7vph kernel: ADDRCONF(NETDEV_UP): wlan0: link is
>> not ready
>> Apr 27 01:32:40 linux-7vph sudo:   niella : TTY=pts/2 ; PWD=/home/niella
>> ; USER=root ; COMMAND=/usr/bin/tail -f /var/log/messages
>> Apr 27 01:33:16 linux-7vph kernel: wlan0: direct probe to AP
>> 00:1d:92:1d:1e:8e try 1
>> Apr 27 01:33:16 linux-7vph kernel: wlan0: direct probe to AP
>> 00:1d:92:1d:1e:8e try 2
>> Apr 27 01:33:16 linux-7vph kernel: wlan0: direct probe to AP
>> 00:1d:92:1d:1e:8e try 3
>> Apr 27 01:33:16 linux-7vph kernel: wlan0: direct probe to AP
>> 00:1d:92:1d:1e:8e timed out
>> Apr 27 01:33:29 linux-7vph kernel: wlan0: direct probe to AP
>> 00:1d:92:1d:1e:8e try 1
>> Apr 27 01:33:29 linux-7vph kernel: wlan0: direct probe to AP
>> 00:1d:92:1d:1e:8e try 1
>> Apr 27 01:33:29 linux-7vph kernel: wlan0: direct probe to AP
>> 00:1d:92:1d:1e:8e try 2
>> Apr 27 01:33:29 linux-7vph kernel: wlan0: direct probe to AP
>> 00:1d:92:1d:1e:8e try 3
>> Apr 27 01:33:29 linux-7vph kernel: wlan0: direct probe to AP
>> 00:1d:92:1d:1e:8e timed out
>> Apr 27 01:33:42 linux-7vph kernel: wlan0: direct probe to AP
>> 00:1d:92:1d:1e:8e try 1
>> Apr 27 01:33:42 linux-7vph kernel: wlan0: direct probe to AP
>> 00:1d:92:1d:1e:8e try 1
>> Apr 27 01:33:42 linux-7vph kernel: wlan0: direct probe to AP
>> 00:1d:92:1d:1e:8e try 2
>> Apr 27 01:33:42 linux-7vph kernel: wlan0: direct probe to AP
>> 00:1d:92:1d:1e:8e try 3
>> Apr 27 01:33:43 linux-7vph kernel: wlan0: direct probe to AP
>> 00:1d:92:1d:1e:8e timed out
>>
>> I do not have any similar problems with 2.6.29 or 2.6.28 at the exact
>> same physical location.
>>
>> I can try to bisect in a day or two if need be.
>>     
>
> >From what I can tell we did not send any iwlagn patches to 2.6.30 that
> are related to this behavior. Please do try a bisect. 
>   
Okidoki, I've managed to bisect it:

commit 47afbaf5af9454a7a1a64591e20cbfcc27ca67a8
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Tue Apr 7 15:22:28 2009 +0200

    mac80211: correct wext transmit power handler
---------

Under normal working circumstances, I get a reported 30-42% signal
strength to my wireless router, with the problematic kernels I just kept
getting probe attempts followed by the timeout, as per my original post.

Regards,
Niel
