Return-Path: <linux-kernel-owner+w=401wt.eu-S1752330AbZITV4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330AbZITV4S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 17:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbZITV4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 17:56:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbZITV4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 17:56:17 -0400
Message-ID: <4AB6A4EE.3060904@redhat.com>
Date: Mon, 21 Sep 2009 00:55:58 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: "Langsdorf, Mark" <mark.langsdorf@amd.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Prevent immediate process rescheduling
References: <200909181449.12311.mark.langsdorf@amd.com>	 <20090918195455.GC11726@elte.hu> <1253304203.10538.64.camel@laptop> <4AB496ED.7010800@redhat.com> <DDE95BDD51FB774B804A9C029E735EE10379BEDA2F@sausexmbp02.amd.com>
In-Reply-To: <DDE95BDD51FB774B804A9C029E735EE10379BEDA2F@sausexmbp02.amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2009 12:03 AM, Langsdorf, Mark wrote:
>> - we can pick one of the vcpus belonging to the same guest to improve
>> the probability that the lock actually get released
>>      
> Is there a way to find the other vcpus belonging to the
> same guest?  I poked around at that, but couldn't find
> one.
>    

vcpu->kvm->vcpus[].  It doesn't give you the task_struct, but we can 
easily save it in vcpu_load() and release it in vcpu_put().


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

