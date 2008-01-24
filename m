Return-Path: <linux-kernel-owner+w=401wt.eu-S1754973AbYAXRKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973AbYAXRKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 12:10:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbYAXRKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 12:10:05 -0500
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:25401 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbYAXRKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 12:10:03 -0500
Message-ID: <4798C664.1040409@fr.ibm.com>
Date: Thu, 24 Jan 2008 18:09:56 +0100
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Pavel Emelyanov <xemul@openvz.org>,
       Linux Containers <containers@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Extend sys_clone and sys_unshare system calls API
References: <478DFF8F.9030006@openvz.org> <20080123205930.GA5233@ucw.cz>
In-Reply-To: <20080123205930.GA5233@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Wed 2008-01-16 15:58:55, Pavel Emelyanov wrote:
>> There's only one bit in the clone_flags left, so we won't be able 
>> to create more namespaces after we make it busy. Besides, for 
>> checkpoint/restart jobs we might want to create tasks with given
>> pids (virtual of course). And nobody knows for sure what else might 
>> be required from clone() in the future.
>>
>> This is an attempt to create a extendable API for clone and unshare.
>> Actually this patch is a request for comment about the overall
>> design. If it will turn out to "look good", then we'll select some
>> better names for new flag and data types.
>>
>> I use the last bit in the clone_flags for CLONE_LONGARG. When set it
>> will denote that the child_tidptr is not a pointer to a tid storage,
>> but the pointer to the struct long_clone_struct which currently 
>> looks like this:
>>
>> struct long_clone_arg {
>> 	int size;
>> };
> 
> Ugly as night, I'd say. (Al said it better). What about just adding
> clone2 syscall, that takes u64?

yes but we would need more something like  : 

 long sys_clone64(unsigned long flags_high, unsigned long flag_low)

if we want the syscall to be supported on 32bit arch. clone2 is also 
being used on ia64 already.

C.
