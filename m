Return-Path: <linux-kernel-owner+w=401wt.eu-S1756742AbYKQEvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbYKQEvc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 23:51:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756079AbYKQEvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 23:51:24 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:35128 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756018AbYKQEvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 23:51:24 -0500
Message-ID: <4920F7F7.6050601@linux.vnet.ibm.com>
Date: Mon, 17 Nov 2008 10:19:59 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: linux-mm@kvack.org, YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [mm] [PATCH 4/4] Memory cgroup hierarchy feature selector (v4)
References: <20081116081034.25166.7586.sendpatchset@balbir-laptop> <20081116081105.25166.54820.sendpatchset@balbir-laptop> <4920F70D.9030100@cn.fujitsu.com>
In-Reply-To: <4920F70D.9030100@cn.fujitsu.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
>> +	/*
>> +	 * If parent's use_hiearchy is set, we can't make any modifications
>> +	 * in the child subtrees. If it is unset, then the change can
>> +	 * occur, provided the current cgroup has no children.
>> +	 *
>> +	 * For the root cgroup, parent_mem is NULL, we allow value to be
>> +	 * set if there are no children.
>> +	 */
>> +	if (!parent_mem || (!parent_mem->use_hierarchy &&
>> +				(val == 1 || val == 0))) {
> 
> Should be :
> 
> if ((!parent_mem || !parent_mem->use_hierarchy) &&
>     (val == 1 || val == 0)) {

Yes, we need to validate values for root cgroup as well. Thanks for the comments

-- 
	Balbir
