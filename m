Return-Path: <linux-kernel-owner+w=401wt.eu-S1755171AbYBPJdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbYBPJdW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 04:33:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbYBPJdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 04:33:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50445 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbYBPJdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 04:33:11 -0500
Message-ID: <47B6AD86.2060802@cn.fujitsu.com>
Date: Sat, 16 Feb 2008 17:31:50 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Paul Menage <menage@google.com>, balbir@in.ibm.com, pj@sgi.com,
       Pavel Emelianov <xemul@openvz.org>, vatsa@linux.vnet.ibm.com,
       akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/7] CGroup API: More structured API for CGroups
 control files
References: <20080215204418.535025000@menage.corp.google.com> <20080216132118.877e769b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080216132118.877e769b.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Fri, 15 Feb 2008 12:44:18 -0800
> Paul Menage <menage@google.com> wrote:
> 
>> This set of patches makes the Control Groups API more structured and
>> self-describing.
>>
>> 1) Allows control files to be associated with data types such as
>> "u64", "string", "map", etc. These types show up in a new cgroup.api
>> file in each cgroup directory, along with a user-readable
>> string. Files that use cgroup-provided data accessors have these file
>> types inferred automatically.
>>
>> 2) Moves various files in cpusets and the memory controller from using
>> custom-written file handlers to cgroup-defined handlers
>>
>> 3) Adds the "cgroup." prefix for existing cgroup-provided control
>> files (tasks, release_agent, releasable, notify_on_release). Given
>> than we've already had 2.6.24 go out without this prefix, I guess this
>> could be a little contentious - but it seems like a good move to
>> prevent name clashes in the future. (Note that this doesn't affect
>> mounting the legacy cpuset filesystem, since the compatibility layer
>> disables all prefixes when mounted with filesystem type "cpuset"). If
>> people object too strongly, we could just make this the case for *new*
>> cgroup API files, but I think this is a case where consistency would
>> be better than compatibility - I'd be surprised if anyone has written
>> major legacy apps yet that rely on 2.6.24 cgroup control file names.
>>
> 
> 
> Hi,  I like this direction very much. thank you for your work.
> Self-describing cgroup.api file is a good idea!
> 
> One request from me is add "mode" bit to cftype for allowing
> write-only/read-only files. 
> 
> Thanks,
> -Kame
> 

I don't quite catch what you mean. Cgoup does support write-only/read-only
files. For a write-only file, just set .write and .write_uint to be NULL,
similar for a read-only file.

Do I miss something?
