Return-Path: <linux-kernel-owner+w=401wt.eu-S1755081AbZGBOVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbZGBOVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 10:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbZGBOVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 10:21:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60498 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724AbZGBOVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 10:21:00 -0400
Message-ID: <4A4CC2BF.3030809@redhat.com>
Date: Thu, 02 Jul 2009 17:22:55 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
       davidel@xmailserver.org
Subject: Re: [KVM PATCH v8 3/3] KVM: create irqfd-cleanup-wq on demand
References: <20090701160208.3615.99153.stgit@dev.haskins.net> <20090701160913.3615.35388.stgit@dev.haskins.net>
In-Reply-To: <20090701160913.3615.35388.stgit@dev.haskins.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2009 07:09 PM, Gregory Haskins wrote:
> We currently create this wq on module_init, which may be wasteful if the
> host never creates a guest that uses irqfd.  This patch changes the
> algorithm so that the workqueue is only created when at least one guest
> is using irqfd.  The queue is cleaned up when the last guest using irqfd
> is shutdown.
>
> To keep things simple, we only check whether the guest has tried to create
> an irqfd, not whether there are actually irqfds active.
>    

> +++ b/include/linux/kvm_host.h
> @@ -144,6 +144,7 @@ struct kvm {
>   	struct {
>   		spinlock_t        lock;
>   		struct list_head  items;
> +		int               init:1;
>    

Since you're rebasing anyway... change the bitfield to a bool.

-- 
error compiling committee.c: too many arguments to function

