Return-Path: <linux-kernel-owner+w=401wt.eu-S1760568AbXIRQlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760568AbXIRQlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 12:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759142AbXIRQlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 12:41:07 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:44578 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755462AbXIRQlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 12:41:05 -0400
Message-ID: <46EFFF9D.6090609@us.ibm.com>
Date: Tue, 18 Sep 2007 09:41:01 -0700
From: David Wilder <dwilder@us.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, SystemTAP <systemtap@sources.redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH 0/2] A kernel tracing interface
References: <46E9CB0D.2040206@us.ibm.com> <20070914174953.04b0b158.akpm@linux-foundation.org>
In-Reply-To: <20070914174953.04b0b158.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 13 Sep 2007 16:43:09 -0700
> David Wilder <dwilder@us.ibm.com> wrote:
> 
>> These patches provide a kernel tracing interface called "trace".
>>
>> The motivation for "trace" is to:
>> - Provide a simple set of tracing primitives that will utilize the high-
>>   performance and low-overhead of relayfs for passing traces data from
>>   kernel to user space.
>> - Provide a common user interface for managing kernel traces.
>> - Allow for binary as well as ascii trace data.
>> - Incorporate features from the systemtap runtime that are
>>   useful to others.
>>
>> History- Versions of this code have been submitted for review under
>> a couple of different names.  The original submission was called UTT,
>> it was later re-submitted as GTSC.   Christoph Hellwig commented "The
>> code looks fine ...but the name is just dumb".  Following Christoph's
>> advice, I changed the name to simply "Trace".
>>
>> This patch addresses review comments made by Christoph Hellwig and Mathieu
>> Desnoyers.  Changes include the addition of a mutex and synchronization
>> protecting trace state changes (using RCU) and the reduction of the
>> number of exports.
>>
>> Patches are against 2.6.23-rc4-mm1
>>
>> Required patches:
>> 1/2 Trace code and documentation
>> 2/2 Relay reset consumed  (required for trace's "rewind" feature")
>>
>> Signed-off-by: David Wilder <dwilder@us.ibm.com>
> 
> Well the code looks neat and easy enough to merge.
> 
> What exactly is the relationship between this and systemtap and kprobes and
> all the other tracing things which people are doing?
> 
> 
The key to the relationship is relay.  Systemtap, kprobes, blktrace 
,(and others) need the fast user-kernel data hose that relay provides. 
Trace is a means to simplify and standardize the use of relay. 
Systemtap adopted this code some time ago in its own runtime.  Moving 
this code into the kernel will allow other tracers to take advantage of 
the same trace primitives.
