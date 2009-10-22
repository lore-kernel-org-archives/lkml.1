Return-Path: <linux-kernel-owner+w=401wt.eu-S1756114AbZJVPUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbZJVPUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 11:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755670AbZJVPUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 11:20:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755467AbZJVPUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 11:20:06 -0400
Message-ID: <4AE07814.6020906@redhat.com>
Date: Thu, 22 Oct 2009 17:19:48 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: Gleb Natapov <gleb@redhat.com>, Gregory Haskins <ghaskins@novell.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       alacrityvm-devel@lists.sourceforge.net
Subject: Re: [KVM PATCH 1/2] KVM: Directly inject interrupts via irqfd
References: <20091021143042.14955.22470.stgit@dev.haskins.net> <20091021143453.14955.80578.stgit@dev.haskins.net> <20091021152621.GR29477@redhat.com> <4ADF2A1B.3010205@gmail.com> <20091021153640.GS29477@redhat.com> <4ADF2BDD.40706@gmail.com> <4AE07541.8060903@redhat.com> <4AE076E0.7030100@gmail.com>
In-Reply-To: <4AE076E0.7030100@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2009 05:14 PM, Gregory Haskins wrote:
> Yeah, I was thinking about that after I initially responded to Gleb.
>
> I am thinking something along these lines:
>
> Provide a function that lets you query a GSI for whether it supports
> LOCKLESS or not.  Then we can either do one of two things:
>
> 1) Check for the LOCKLESS attribute at irqfd registration, fail if not
> present
>    

This is the most practical path and leads to the smallest code.  However 
it has the deficiency of exposing internal implementation details to 
userspace.  In theory userspace could use msi and edge-triggered 
pic/ioapic interrupts equally well, it shouldn't have to know that we 
didn't bother to lockfree ioapic/pic.

> 2) Cache the LOCKLESS attribute in the irqfd structure, and either go
> direct or defer to a workqueue depending on the flag.
>    

While this leads to larger code, it is more consistent.

-- 
error compiling committee.c: too many arguments to function

