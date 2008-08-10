Return-Path: <linux-kernel-owner+w=401wt.eu-S1753723AbYHJR5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbYHJR5l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 13:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbYHJR50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 13:57:26 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:46084 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752526AbYHJR5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 13:57:25 -0400
Message-ID: <489F2C00.3080608@opengridcomputing.com>
Date: Sun, 10 Aug 2008 12:57:20 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: rdreier@cisco.com, jgarzik@pobox.com, divy@chelsio.com, kxie@chelsio.com,
       netdev@vger.kernel.org, open-iscsi@googlegroups.com,
       michaelc@cs.wisc.edu, daisyc@us.ibm.com, wenxiong@us.ibm.com,
       bhua@us.ibm.com, dm@chelsio.com, leedom@chelsio.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/1] cxgb3i: cxgb3 iSCSI initiator
References: <489CC58D.4010606@pobox.com>	<20080809.002840.167363463.davem@davemloft.net>	<adavdy9zc2k.fsf@cisco.com> <20080809.224725.130946315.davem@davemloft.net>
In-Reply-To: <20080809.224725.130946315.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Roland Dreier <rdreier@cisco.com>
> Date: Sat, 09 Aug 2008 22:14:11 -0700
>
>   
>>  > Also, I find it ironic that the port abduction is being asked for in
>>  > order to be "compatible with existing tools" yet in fact this stuff
>>  > breaks everything.  You can't netfilter this traffic, you can't apply
>>  > qdiscs to it, you can't execut TC actions on them, you can't do
>>  > segmentation offload on them, you can't look for the usual TCP MIB
>>  > statistics on the connection, etc. etc. etc.
>>
>> We already support offloads that break other features, eg large receive
>> offload breaks forwarding.  We deal with it.
>>     
>
> We turn it off.  If I want to shape or filter one of these iSCSI
> connections can we turn it off?
>
>   
Sure.

Seems to me we _could_ architect this all so that these devices would 
have to support a method for the management/admin tools to tweak, and if 
nothing else kill, offload connections if policy rules change and the 
existing connections aren't implementing the policy.  IE: if the offload 
connection doesn't support whatever security or other facilities that 
the admin requires, then the admin should have the ability to disable 
that device.  And of course, some devices will allow doing things like 
netfilter, qos, tweaking vlan tags, etc even on active connection,  if 
the OS infrastructure is there to hook it all up.

BTW:  I think all these offload devices provide MIBs and could be pulled 
in to the normal management tools.


Steve.
