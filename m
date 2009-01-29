Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbZA2Ebm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbZA2Ebm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 23:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757850AbZA2Eb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 23:31:28 -0500
Received: from gw.goop.org ([64.81.55.164]:39917 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757820AbZA2Eb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 23:31:28 -0500
Message-ID: <4981311D.9080205@goop.org>
Date: Wed, 28 Jan 2009 20:31:25 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stable Kernel <stable@kernel.org>,
       "dan.magenheimer@oracle.com" <dan.magenheimer@oracle.com>
Subject: Re: [PATCH] xen: make sysfs files behave as their names suggest
References: <4980FD4C.3030700@goop.org> <20090129023516.GB1319@verge.net.au>
In-Reply-To: <20090129023516.GB1319@verge.net.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Horman wrote:
> On Wed, Jan 28, 2009 at 04:50:20PM -0800, Jeremy Fitzhardinge wrote:
>   
>> 1: make "target_kb" only accept and produce a memory size in kilobytes.
>> 2: add a second "target" file which produces output in bytes, and will accept
>>   memparse input (scaled bytes)
>>
>> This fixes the rather irritating problem that writing the same value
>> read back into target_kb would end up shrinking the domain by a factor
>> of 1024, with generally bad results.
>>     
>
> Are there any compatibility issues that we should care about
> related to this change?
>   

Well, in theory, but not in practice I think.

It changes the behaviour of target_kb from accepting bytes into 
kilobytes, and it no longer parses a k/m/g suffix.  The old behaviour 
was a definite bug, given the name of the file, so I consider this to be 
pure bugfix.  The kernel introducing this interface has only been out 
for a week or two, so I don't think there's much chance anyone has 
started relying on the buggy behaviour.

    J
