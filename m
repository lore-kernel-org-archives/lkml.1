Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbYIOR7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbYIOR7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 13:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbYIOR70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 13:59:26 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:55601 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670AbYIOR7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 13:59:25 -0400
Message-ID: <48CEA1B1.50401@cs.helsinki.fi>
Date: Mon, 15 Sep 2008 20:56:01 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       balbir@linux.vnet.ibm.com
Subject: Re: [PATCH] cgroups: don't depend on CONFIG_MM_OWNER
References: <Pine.LNX.4.64.0809142037070.30252@melkki.cs.Helsinki.FI> <6599ad830809151055v10191becl2f528fa006902b40@mail.gmail.com>
In-Reply-To: <6599ad830809151055v10191becl2f528fa006902b40@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Paul Menage wrote:
> On Sun, Sep 14, 2008 at 10:37 AM, Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
>> From: Pekka Enberg <penberg@cs.helsinki.fi>
>>
>> The revoke patches, for example, select CONFIG_MM_OWNER independently of
>> cgroups. Therefore, don't depend on CONFIG_MM_OWNER in cgroup specific code.
> 
> Yes, the existing code doesn't seem quite right - if !CONFIG_MM_OWNER
> then we don't need to even define a trivial version of
> cgroup_mm_owner_callbacks()
> 
> But your patch is too specific - tying the existance of
> cgroup_mm_owner_callbacks() to the memory controller would break other
> controllers (e.g. the memrlimit or swap controllers, which also want
> to use it)
> 
> How about:
> 
> - any cgroup that needs mm-owner callbacks selects an option
> CGROUP_MM_OWNER_CALLBACK
> 
> - CGROUP_MM_OWNER_CALLBACK selects MM_OWNER and triggers the
> definition of a non-trivial cgroup_mm_owner_callbacks() function

Yeah, sounds good to me. I just want to be able to select 
CONFIG_MM_OWNER separately for my revoke patches.

		Pekka
