Return-Path: <linux-kernel-owner+w=401wt.eu-S1756113AbZGBOPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbZGBOPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 10:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbZGBOOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 10:14:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41879 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbZGBOOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 10:14:50 -0400
Message-ID: <4A4CC14C.1000905@redhat.com>
Date: Thu, 02 Jul 2009 17:16:44 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
       davidel@xmailserver.org
Subject: Re: [KVM PATCH v8 1/3] KVM: Fix races in irqfd using new eventfd_kref_get
 interface
References: <20090701160208.3615.99153.stgit@dev.haskins.net> <20090701160902.3615.39426.stgit@dev.haskins.net>
In-Reply-To: <20090701160902.3615.39426.stgit@dev.haskins.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2009 07:09 PM, Gregory Haskins wrote:
> eventfd currently emits a POLLHUP wakeup on f_ops->release() to generate a
> "release" callback.  This lets eventfd clients know if the eventfd is about
> to go away and is very useful particularly for in-kernel clients.  However,
> until recently it is not possible to use this feature of eventfd in a
> race-free way.
>
> This patch utilizes a new eventfd interface to rectify the problem.  It also
> converts the eventfd POLLHUP generation code to use the locked variant
> of wakeup.
>
> Signed-off-by: Gregory Haskins<ghaskins@novell.com>
> CC: Davide Libenzi<davidel@xmailserver.org>
> ---
>
>   fs/eventfd.c             |    7 --
>   include/linux/kvm_host.h |    5 +
>   virt/kvm/eventfd.c       |  187 ++++++++++++++++++++++++++++++++--------------
>   3 files changed, 134 insertions(+), 65 deletions(-)
>    


Please split the eventfd.c hunk into a separate patch.  When preparing 
the 2.6.32 submission, I'll fold that into the patch into its antipatch 
and they'll disappear.

-- 
error compiling committee.c: too many arguments to function

