Return-Path: <linux-kernel-owner+w=401wt.eu-S1754457AbYIZJb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457AbYIZJb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 05:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbYIZJbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 05:31:18 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:54694 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbYIZJbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 05:31:18 -0400
Message-ID: <48DCAB8C.5030405@linux.vnet.ibm.com>
Date: Fri, 26 Sep 2008 14:59:48 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080725)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "xemul@openvz.org" <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Dave Hansen <haveblue@us.ibm.com>,
       ryov@valinux.co.jp
Subject: Re: [PATCH 3/12] memcg make root cgroup unlimited.
References: <20080925151124.25898d22.kamezawa.hiroyu@jp.fujitsu.com> <20080925151543.ba307898.kamezawa.hiroyu@jp.fujitsu.com> <48DCA01C.9020701@linux.vnet.ibm.com> <20080926182122.c7c88a65.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080926182122.c7c88a65.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Fri, 26 Sep 2008 14:11:00 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> KAMEZAWA Hiroyuki wrote:
>>> Make root cgroup of memory resource controller to have no limit.
>>>
>>> By this, users cannot set limit to root group. This is for making root cgroup
>>> as a kind of trash-can.
>>>
>>> For accounting pages which has no owner, which are created by force_empty,
>>> we need some cgroup with no_limit. A patch for rewriting force_empty will
>>> will follow this one.
>>>
>>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> This is an ABI change (although not too many people might be using it, I wonder
>> if we should add memory.features (a set of flags and let users enable them and
>> provide good defaults), like sched features.
>>
> I think "feature" flag is complicated, at this stage.
> We'll add more features and not settled yet.
> 

I know.. but breaking ABI is a bad bad thing. We'll have to keep the feature
flags extensible (add new things). If we all feel we don't have enough users
affected by this change, I might agree with you and make that change.

> Hmm, if you don't like this,
> calling try_to_free_page() at force_empty() instead of move_account() ?
> 

Not sure I understand this.


-- 
	Balbir
