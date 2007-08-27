Return-Path: <linux-kernel-owner+w=401wt.eu-S1755878AbXH0L2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbXH0L2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 07:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbXH0L2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 07:28:36 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:32919 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275AbXH0L2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 07:28:35 -0400
Message-ID: <46D2A9D3.50703@linux.vnet.ibm.com>
Date: Mon, 27 Aug 2007 16:09:15 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
CC: akpm@linux-foundation.org, npiggin@suse.de, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, ebiederm@xmission.com, containers@lists.osdl.org,
       menage@google.com, xemul@openvz.org
Subject: Re: [-mm PATCH 5/10] Memory controller task migration (v7)
References: <20070824152043.16582.37727.sendpatchset@balbir-laptop> <20070827082635.195471BFA2C@siro.lan>
In-Reply-To: <20070827082635.195471BFA2C@siro.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

YAMAMOTO Takashi wrote:
>> Allow tasks to migrate from one container to the other. We migrate
>> mm_struct's mem_container only when the thread group id migrates.
> 
>> +	/*
>> +	 * Only thread group leaders are allowed to migrate, the mm_struct is
>> +	 * in effect owned by the leader
>> +	 */
>> +	if (p->tgid != p->pid)
>> +		goto out;
> 
> does it mean that you can't move a process between containers
> once its thread group leader exited?
> 
> YAMAMOTO Takashi


Hi,

Good catch! Currently, we treat the mm as owned by the thread group leader.
But this policy can be easily adapted to any other desired policy.
Would you like to see it change to something else?

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
