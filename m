Return-Path: <linux-kernel-owner+w=401wt.eu-S1753471AbYC3OMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbYC3OMc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 10:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbYC3OMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 10:12:23 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:55046 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbYC3OMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 10:12:22 -0400
Message-ID: <47EF9FC2.3050901@colorfullife.com>
Date: Sun, 30 Mar 2008 16:12:18 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       paulmck@linux.vnet.ibm.com, Nadia Derbey <Nadia.Derbey@bull.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Pavel Emelianov <xemul@openvz.org>
Subject: Re: Scalability requirements for sysv ipc (+namespaces broken with
 SEM_UNDO)
References: <47E382DB.70503@colorfullife.com> <47E3ADE3.4030304@bull.net> <47E3B924.3000304@colorfullife.com> <20080321141339.GB9618@linux.vnet.ibm.com> <47E3DD8C.4000904@colorfullife.com> <1206164608.3659.11.camel@marge.simson.net> <47E4DB06.3020003@colorfullife.com> <1206186832.4545.1.camel@marge.simson.net> <47E51637.8060102@colorfullife.com>  <47E55945.10109@colorfullife.com> <1206460206.4414.21.camel@marge.simson.net>
In-Reply-To: <1206460206.4414.21.camel@marge.simson.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:
> On Sat, 2008-03-22 at 20:08 +0100, Manfred Spraul wrote:
>
>   
>> just the normal performance of 2.6.25-rc3 is abyssimal, 55 to 60% slower 
>> than 2.6.18.8:
>>     
>
> After manually reverting 3e148c79938aa39035669c1cfa3ff60722134535,
> 2.6.25.git scaled linearly
We can't just revert that patch: with IDR, a global lock is mandatory :-(
We must either revert the whole idea of using IDR or live with the 
reduced scalability.

Actually, there are further bugs: the undo structures are not 
namespace-aware, thus semop with SEM_UNDO, unshare, create new array 
with same id, but more semaphores, another semop with SEM_UNDO will 
corrupt kernel memory :-(
I'll try to clean up the bugs first, then I'll look at the scalability 
again.

--
    Manfred
