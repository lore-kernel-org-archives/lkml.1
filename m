Return-Path: <linux-kernel-owner+w=401wt.eu-S1756759AbZCDMCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759AbZCDMCZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 07:02:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbZCDMCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 07:02:11 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:33272 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbZCDMCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 07:02:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=T4mFlz3isGuexmPX+itnvylHmZSDbJ5EFGDfRBD49tYEc1SDPtDA6QLgPWAwv4aGDS
         yZKkmv4XWTP4MqE6BlyZeTEVBko9MEYqYD5wTRI7CkrpvSLnHjEML8O8AAvQmmNiaMX8
         pO/JJKr0G2VVCj/PXFA3aXI3z3DuQG9cODOI4=
Message-ID: <49AE6DBC.4060401@gmail.com>
Date: Wed, 04 Mar 2009 14:02:04 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Jason Baron <jbaron@redhat.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2] tracing: lockdep tracepoints
References: <1236164586.5330.7142.camel@laptop>	 <20090304112345.GB6032@nowhere> <1236166375.5330.7209.camel@laptop>
In-Reply-To: <1236166375.5330.7209.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-03-04 13:32, Peter Zijlstra wrote:
> On Wed, 2009-03-04 at 12:23 +0100, Frederic Weisbecker wrote:
>   
>>> ---
>>> Subject: tracing: lockdep tracepoints
>>> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
>>> Date: Tue Mar 03 22:03:08 CET 2009
>>>
>>> Augment the traces with lock names when lockdep is available:
>>>
>>>  1)               |  down_read_trylock() {
>>>  1)               |    _spin_lock_irqsave() {
>>>  1)               |      /* lock_acquire: name: &sem->wait_lock */
>>>  1)   4.201 us    |    }
>>>  1)               |    _spin_unlock_irqrestore() {
>>>  1)               |      /* lock_release: name: &sem->wait_lock */
>>>       
>> Nice idea.
>> I would just suggest to drop the "name:" since the comment is intuitive enough
>> to figure out what we have after lock_{release,acquire}: 
>>     
>
> Makes sense I guess..
>
> Here goes.. one s/name: //g later

Thanks for working on this.
I just booted a kernel with your patch, and it worked.

When I find some time, I will try to write a locklatency tracer that
uses these tracepoints.

Best regards,
--Edwin
