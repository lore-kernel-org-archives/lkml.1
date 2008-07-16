Return-Path: <linux-kernel-owner+w=401wt.eu-S1760131AbYGPPAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760131AbYGPPAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 11:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756768AbYGPPAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 11:00:06 -0400
Received: from main.gmane.org ([80.91.229.2]:50830 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757194AbYGPPAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 11:00:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Holger Hoffstaette" <holger@wizards.de>
Subject: Re: sendfile() broken with 2.6.26 + Apache 2 ?
Date: Wed, 16 Jul 2008 16:58:08 +0200
Organization: The Fists of the White Lotus
Message-ID: <pan.2008.07.16.14.58.05.879125@wizards.de>
References: <487CD7A7.2080800@jeffray.co.uk> <487D893A.5080207@cosmosbay.com> <487DA388.3030104@jeffray.co.uk> <487DBA74.3090800@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: port-87-234-135-63.dynamic.qsc.de
User-Agent: Pan/0.13.91 (Before we let euphoria convince us we are free)
Cc: netdev@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jul 2008 11:08:04 +0200, Eric Dumazet wrote:

> Ian Jeffray a écrit :
>> Hi Eric,
>> 
>> Thanks for directing me to a better list.
>> 
>> Further responses below:
>> 
>> Eric Dumazet wrote:
>>> CC to netdev where this report might find better answers
>>>
>>> Ian Jeffray a écrit :
>>>> All,
>>>>
>>>> I moved from kernel 2.6.25.4 to 2.6.26 yesterday and observed that
>>>> large files sent via Apache2 are partially corrupt.
>>>>
>>>> This appears to be linked to sendfile() -- disabling the use of
>>>> sendfile in the apache config (EnableSendfile Off) allows it to
>>>> function as normal.
>>>>
>>>> My system is a simple Core2Duo running Debian lenny/sid; nothing
>>>> special, and I have never observed problems like this before.
>>>>
>>>> The problem feels certainly related to sendfile() since the data reads
>>>> correctly from disc in other programs, and via CIFS etc.
>>>>
>>>> The corruption happens part-way in to the file... I've no exact figure
>>>> but it would seem like maybe 32KB -- I'm seeing broken PNGs served
>>>> from Apache, where the top few dozen lines decode correctly, and the
>>>> rest is garbage.
>>>>
>>>> I've made basically no configuration changes between 2.6.25.4 and
>>>> 2.6.26 and have explicitly tried both enabling and disabling the new
>>>> PAT support to no effect.
>>>>
>>>> This is completely repeatable and reproducible.
>>>>
>>>> Is anyone else seeing this broken behaviour?
>>>>
>>>>
>>>
>>> What kind of network adapter are you using ? (lspci | grep -i ether)
>> 
>> 02:00.0 Ethernet controller: Attansic Technology Corp. L1 Gigabit
>> Ethernet Adapter (rev b0)
>> 
>> 
>>> If you disable TCP segmentation offload on this NIC (ethtool -K eth0
>>> tso off) , is this problem still present ?
>> 
>> Wow.  That 'solves' the problem!  Great.
>> 
>> Does this therefore point to an attansic driver issue?
> 
> Yes, maybe related to commit 9d90fb1ac9d97da86e24d9ea947bf2a2f333829a
> 
> In this patch, Jay Cliburn enabled TSO by default for atl1 driver.
> 
> This might be a driver problem, or a generic sendfile() problem, I dont
> know...

Maybe related to http://lkml.org/lkml/2007/12/6/229 ?
I switched to a different server with e1000 NIC in the meantime and so I
cannot test if this is still a problem in 2.6.26, but apparently it seems
so. For me the combo e1000/e1000e + sendfile works reliably..

Holger


