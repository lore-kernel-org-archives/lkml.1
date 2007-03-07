Return-Path: <linux-kernel-owner+w=401wt.eu-S1030792AbXCGJRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030792AbXCGJRN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 04:17:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030793AbXCGJRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 04:17:12 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:56509 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030792AbXCGJRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 04:17:10 -0500
Message-ID: <45EE8315.3020800@vmware.com>
Date: Wed, 07 Mar 2007 01:17:09 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       virtualization <virtualization@lists.osdl.org>,
       Roland McGrath <roland@redhat.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jan Beulich <jbeulich@novell.com>,
       Daniel Hecht <dhecht@vmware.com>
Subject: Re: Xen & VMI?
References: <45ED82D9.6050204@codemonkey.ws> <8FFF7E42E93CC646B632AB40643802A80229779B@scsmsx412.amr.corp.intel.com> <20070306203712.GC21736@elte.hu> <1173228246.4644.85.camel@localhost.localdomain> <20070307081510.GB15111@elte.hu>
In-Reply-To: <20070307081510.GB15111@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> For example, VMI_CALL_SetAlarm takes a 'cycles' argument. Cycles is a 
> quite bad unit for an API, it should be absolute time, nanosec or 
> picosec based instead. We could easily see CPUs that have /no concept of 
>   

Actually, putting the unit in terms of cycles is more portable and 
flexible.  Rather than perform a conversion from cycles to 
nano/femto/pico seconds, the raw cycle count is exposed, along with the 
current clock frequency.  This allows the timer infrastructure to merely 
do one conversion, from cycles to real time, rather than converting to 
an arbitrary time unit which may change with operating systems and time 
and thus break the ABI.

Zach
