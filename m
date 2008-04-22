Return-Path: <linux-kernel-owner+w=401wt.eu-S1757702AbYDVMky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702AbYDVMky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 08:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbYDVMkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 08:40:45 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:57720 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbYDVMkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 08:40:45 -0400
Message-ID: <480DDCCA.4010709@de.ibm.com>
Date: Tue, 22 Apr 2008 14:40:42 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: ltp-list@lists.sourceforge.net, Andrew Morton <akpm@linux-foundation.org>,
       ltp-coverage@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Ltp-coverage] [RFC PATCH 5/8] module: add function to map	address
 to containing module
References: <480C89DF.9090905@de.ibm.com> <200804220140.58784.rusty@rustcorp.com.au>
In-Reply-To: <200804220140.58784.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Monday 21 April 2008 22:34:39 Peter Oberparleiter wrote:
>> From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
>>
>> module_address() maps an address to the module containing it in either
>> text or data section. Required by the gcov profiling infrastructure to
>> associate profiling data structures with modules.
> 
> Locking problem; this isn't safe.  Note that we block preemption to traverse 
> the module list.  You could grab a reference, and fix up all the callers to 
> put it once they're done?

Hm, problem: in this patchset, module_address() is called when the module is going (mod->state = MODULE_STATE_GOING) and try_module_get() would most likely fail and/or make no sense since we're already past reference counting with this module anyway.

On the other hand, what I actually need is a way to find out if a given module contains a certain address so I could replace this function with something like module_contains(mod, addr). 
I'll go that route if there are no objections.


Regards,
  Peter
