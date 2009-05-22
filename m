Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbZEVIzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbZEVIzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 04:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755485AbZEVIzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 04:55:46 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:55928 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649AbZEVIzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 04:55:46 -0400
Message-ID: <4A16686C.7060800@linux.vnet.ibm.com>
Date: Fri, 22 May 2009 10:55:08 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Li Wei <W.Li@Sun.COM>, Michael Ellerman <michaele@au1.ibm.com>,
       Heiko Carstens <heicars2@linux.vnet.ibm.com>,
       Martin Schwidefsky <mschwid2@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/4] gcov: add gcov profiling infrastructure
References: <20090519142416.356254359@linux.vnet.ibm.com> <20090519142418.583158351@linux.vnet.ibm.com> <20090519150031.GA21271@elte.hu>
In-Reply-To: <20090519150031.GA21271@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Peter Oberparleiter <oberpar@linux.vnet.ibm.com> wrote:
> 
>> +int __gcov_execve(const char *path, char *const argv[], char *const envp[])
>> +{
>> +	return kernel_execve(path, argv, envp);
>> +}
>> +EXPORT_SYMBOL(__gcov_execve);
> 
> Looks weird, why is this needed?

When compiling with -fprofile-arcs, gcc will turn execve calls into a 
builtin which calls __gcov_execve(). This is needed in userspace to 
ensure that data for the calling process is correctly saved.

Back when kernel_execve() used to be called execve(), this function was 
required to prevent linker errors. If it's generally agreed not to name 
kernel functions execve(), this one might as well be removed (not sure 
about such an agreement though).

