Return-Path: <linux-kernel-owner+w=401wt.eu-S1756602AbYBYRYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602AbYBYRYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 12:24:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbYBYRX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 12:23:59 -0500
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:49554 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbYBYRX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 12:23:58 -0500
Message-ID: <47C2F86A.9010709@linux.vnet.ibm.com>
Date: Mon, 25 Feb 2008 22:48:34 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] Memory Resource Controller Add Boot Option
References: <20080225115509.23920.66231.sendpatchset@localhost.localdomain> <20080225115550.23920.43199.sendpatchset@localhost.localdomain> <6599ad830802250816m1f83dbeekbe919a60d4b51157@mail.gmail.com>
In-Reply-To: <6599ad830802250816m1f83dbeekbe919a60d4b51157@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Mon, Feb 25, 2008 at 3:55 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>
>>  A boot option for the memory controller was discussed on lkml. It is a good
>>  idea to add it, since it saves memory for people who want to turn off the
>>  memory controller.
>>
>>  By default the option is on for the following two reasons
>>
>>  1. It provides compatibility with the current scheme where the memory
>>    controller turns on if the config option is enabled
>>  2. It allows for wider testing of the memory controller, once the config
>>    option is enabled
>>
>>  We still allow the create, destroy callbacks to succeed, since they are
>>  not aware of boot options. We do not populate the directory will
>>  memory resource controller specific files.
> 
> Would it make more sense to have a generic cgroups boot option for this?
> 
> Something like cgroup_disable=xxx, which would be parsed by cgroups
> and would cause:
> 
> - a "disabled" flag to be set to true in the subsys object (you could
> use this in place of the mem_cgroup_on flag)
> 

I thought about it, but it did not work out all that well. The reason being,
that the memory controller is called in from places besides cgroup.
mem_cgroup_charge_common() for example is called from several places in mm.
Calling into cgroups to check, enabled/disabled did not seem right.

Hence I put the boot option in mm/memcontrol.c

> - prevent the disabled cgroup from being bound to any mounted
> hierarchy (so it would be ignored in a mount with no subsystem
> options, and a mount with options that specifically pick that
> subsystem would give an error)
> 

The controller can be bound, but I just don't populate the files associated with
the controller

> Paul


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
