Return-Path: <linux-kernel-owner+w=401wt.eu-S1759933AbZDCHah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759933AbZDCHah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 03:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbZDCHa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 03:30:28 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:35664 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbZDCHa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 03:30:27 -0400
Message-ID: <49D5BB05.2030700@linux.vnet.ibm.com>
Date: Fri, 03 Apr 2009 00:30:13 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] perf_counter: move the event overflow output bits
 to record_type
References: <20090402091158.291810516@chello.nl> <20090402091319.151921176@chello.nl> <49D53D2B.30108@linux.vnet.ibm.com> <49D549E7.1040904@linux.vnet.ibm.com> <1238741404.8530.7068.camel@twins>
In-Reply-To: <1238741404.8530.7068.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2009-04-02 at 16:27 -0700, Corey Ashford wrote:
>> Whoops, nevermind.
>>
>> My misunderstanding on this one.  This enum is used for event type, not 
>> the record_type, and as such is makes sense for there to be exclusive 
>> mmap and munmap event records.
>>
>> Thinking about this a bit, I'm guessing that the idea is to track the 
>> loading and unloading of shared objects which uses mmap and munmap, so 
>> that that the ip can be related to a particular object that was mapped 
>> in at the time of the counter overflow interrupt.  Is that right?
> 
> Indeed, whenever a mmap/munmap happens of a PROT_EXEC range we record
> that information so that we can relate the userspace IPs to some file
> and hence the actual userspace code.

Ah, I see, PROT_EXEC identifies the executable code sections in particular.

Thanks :-)

- Corey

