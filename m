Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840AbYGVKf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbYGVKf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 06:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753350AbYGVKfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 06:35:14 -0400
Received: from stinky.trash.net ([213.144.137.162]:58038 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbYGVKfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 06:35:13 -0400
Message-ID: <4885B7DD.7070507@trash.net>
Date: Tue, 22 Jul 2008 12:35:09 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080405)
MIME-Version: 1.0
To: Ranjit Manomohan <ranjitm@google.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, lizf@cn.fujitsu.com,
       menage@google.com
Subject: Re: [PATCH] Traffic control cgroups subsystem
References: <Pine.LNX.4.64.0807212100580.1760@ranjit.corp.google.com>
In-Reply-To: <Pine.LNX.4.64.0807212100580.1760@ranjit.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ranjit Manomohan wrote:
> 
> [Take 2] - Incorporated comments from Patric McHardy & Li Zefan.
> 
> This patch provides a simple resource controller (cgroup_tc) based on the
> cgroups infrastructure to manage network traffic. The cgroup_tc resource
> controller can be used to schedule and shape traffic belonging to the 
> task(s)
> in a particular cgroup.
> 
> The implementation consists of two parts:
> 
> 1) A resource controller (cgroup_tc) that is used to associate packets from
>    a particular task belonging to a cgroup with a traffic control class 
> id (
>    tc_classid). This tc_classid is propagated to all sockets created by 
> tasks
>    in the cgroup and from there to all packets associated with those 
> sockets.
> 
> 2) A modified traffic control classifier (cls_flow) that can classify 
> packets
>    based on the tc_classid field in the packet to specific destination 
> classes.

Does this really have to be a new skb member? You could
simply use skb->sk->sk_cgroup_classid directly, or if
that doesn't work, maybe skb->priority.
