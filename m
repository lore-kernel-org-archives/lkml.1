Return-Path: <linux-kernel-owner+w=401wt.eu-S1761024AbYDCCbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761024AbYDCCbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 22:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758810AbYDCCbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 22:31:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58996 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758763AbYDCCbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 22:31:15 -0400
Message-ID: <47F440F7.6080308@cn.fujitsu.com>
Date: Thu, 03 Apr 2008 10:29:11 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Paul Menage <menage@google.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] cgroups: introduce cft->read_seq()
References: <20080403010130.GA20543@sergelap.austin.ibm.com> <47F4378A.2000008@cn.fujitsu.com>
In-Reply-To: <47F4378A.2000008@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> Serge E. Hallyn wrote:
>> Hi Paul,
>>
>> the following (against 2.6.25-rc8-mm1) is a first attempt
>> at a simple seq_file usage in cgroups.  Comments much
>> appreciated.
>>
>> thanks,
>> -serge
>>
>> >From bd0977a5819dc43866fff325ae1e2726e747e2f4 Mon Sep 17 00:00:00 2001
>> From: Serge E. Hallyn <serue@us.ibm.com>
>> Date: Wed, 2 Apr 2008 17:54:21 -0700
>> Subject: [PATCH 1/1] cgroups: introduce cft->read_seq()
>>
>> Introduce a read_seq() helper in cftype, which uses
>> seq_file to print out lists.  Use it in the devices
>> cgroup.  Also split devices.allow into two files, so
>> now devices.deny and devices.allow are the ones to
>> use to manipulate the whitelist, while devices.list
>> outputs the cgroup's current whitelist.
>>
>> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
>> ---
>>  include/linux/cgroup.h   |    6 ++++
>>  kernel/cgroup.c          |   22 ++++++++++++-
>>  security/device_cgroup.c |   74 ++++++++++++++-------------------------------
>>  3 files changed, 49 insertions(+), 53 deletions(-)
>>
>> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
>> index 2d1d151..feb83dd 100644
>> --- a/include/linux/cgroup.h
>> +++ b/include/linux/cgroup.h
>> @@ -227,6 +227,12 @@ struct cftype {
>>  	 */
>>  	int (*read_map) (struct cgroup *cont, struct cftype *cft,
>>  			 struct cgroup_map_cb *cb);
>> +	/*
>> +	 * read_seq() is used for outputting a simple sequence
>> +	 * using seqfile.
>> +	 */
>> +	int (*read_seq) (struct cgroup *cont, struct cftype *cft,
>> +			 struct seq_file *m);
>>  
> 
> Can't we remove read_map() ?
> 
> btw: s/cont/cgrp
> 

It seems read_seq() is the general case of read_map(). A read_seq() method can
produce the output freely, and read_map() strictly produces string->u64 maps.

