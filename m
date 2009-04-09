Return-Path: <linux-kernel-owner+w=401wt.eu-S936616AbZDIVhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936616AbZDIVhX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 17:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756436AbZDIVhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 17:37:06 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:34929 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755571AbZDIVhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 17:37:04 -0400
Date: Thu, 9 Apr 2009 14:39:10 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: oleg@redhat.com, linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: LTP 20080131 causes defunct processes w/2.6.30-rc1 (possible
	ptrace issue?)
Message-ID: <20090409213910.GB30645@us.ibm.com>
References: <0CA2FBE3-C50C-4503-9134-6DA1C6965743@kernel.crashing.org> <0D4C1952-792C-4AFF-8969-1EF5386FDAB9@kernel.crashing.org> <20090409194912.GA30645@us.ibm.com> <0D6A6388-C12F-4066-84B8-155381D14504@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0D6A6388-C12F-4066-84B8-155381D14504@kernel.crashing.org>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala [galak@kernel.crashing.org] wrote:
>
> On Apr 9, 2009, at 2:49 PM, Sukadev Bhattiprolu wrote:
>
>> Kumar Gala [galak@kernel.crashing.org] wrote:
>>>
>>> On Apr 9, 2009, at 10:43 AM, Kumar Gala wrote:
>>>
>>>> I'm seeing some weird behavior in 2.6.30-rc1 that didn't exist in 
>>>> 2.6.29.
>>>> We have a slightly older LTP version (20080131) that we run on some
>>>> embedded PPC boards.  If I run the syscall tests on 2.6.29 things pass 
>>>> as
>>
>> Will try to repro on a normal machine, but can you attach the 
>> /proc/pid/status
>> (and possibly the stack) of the parent of the 'recv01' ?
>
> Name:   recv01
> State:  Z (zombie)
> Tgid:   2449
> Pid:    2449
> PPid:   1

Ok, but I meant the status of the parent (i.e /proc/1/status in this case).

To get the stack, if CONFIG_MAGIC_SYSRQ=y, you can:

	$ echo 1 > /proc/sys/kernel/sysrq
	$ echo t > /proc/sysrq-trigger
	$ dmesg > /tmp/dmesg.out

Look in /tmp/dmesg.out for the process stack

Suka
