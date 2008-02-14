Return-Path: <linux-kernel-owner+w=401wt.eu-S934490AbYBNAUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934490AbYBNAUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 19:20:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763988AbYBNAUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 19:20:05 -0500
Received: from vms042pub.verizon.net ([206.46.252.42]:34348 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763103AbYBNAUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 19:20:02 -0500
Date: Wed, 13 Feb 2008 18:20:01 -0600
From: Corey Minyard <minyard@acm.org>
Subject: Re: [PATCH 3/8] IPMI: Run to completion fixes
In-reply-to: <20080213152018.98d427c7.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, openipmi-developer@lists.sourceforge.net
Message-id: <47B38931.8030503@acm.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <20080213162342.GC9830@minyard.local>
 <20080213152018.98d427c7.akpm@linux-foundation.org>
User-Agent: Icedove 1.5.0.14pre (X11/20071018)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 13 Feb 2008 10:23:42 -0600
> Corey Minyard <minyard@acm.org> wrote:
>
>   
>> From: Corey Minyard <cminyard@mvista.com>
>>
>> The "run_to_completion" mode was somewhat broken.  Locks need to be
>> avoided in run_to_completion mode, and it shouldn't be used by normal
>> users, just internally for panic situations.
>>
>> This patch removes locks in run_to_completion mode and removes the
>> user call for setting the mode.  The only user was the poweroff
>> code, but it was easily converted to use the polling interface.
>>
>> +	/*
>> +	 * Spin until our message is done.
>> +	 */
>> +	while (atomic_read(&dummy_count) > 0) {
>> +		ipmi_poll_interface(user);
>> +		barrier();
>> +	}
>>     
>
> we'd normally use cpu_relax() here.
>   
Yes, that's what I should have used.  I'll submit a new patch to fix this.

-corey

