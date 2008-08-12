Return-Path: <linux-kernel-owner+w=401wt.eu-S1753403AbYHLNA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbYHLNA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 09:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbYHLNAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 09:00:14 -0400
Received: from il.qumranet.com ([212.179.150.194]:16334 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110AbYHLNAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 09:00:13 -0400
Message-ID: <48A18958.8060307@qumranet.com>
Date: Tue, 12 Aug 2008 16:00:08 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Avi Kivity <avi@argo.co.il>, kvm-devel <kvm@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] reduce kvm stack usage in kvm_arch_vm_ioctl()
References: <1218474105-14678-1-git-send-email-dave@linux.vnet.ibm.com>
In-Reply-To: <1218474105-14678-1-git-send-email-dave@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On my machine with gcc 3.4, kvm uses ~2k of stack in a few
> select functions.  This is mostly because gcc fails to
> notice that the different case: statements could have their
> stack usage combined.  It overflows very nicely if interrupts
> happen during one of these large uses.
>
> This patch uses two methods for reducing stack usage.
> 1. dynamically allocate large objects instead of putting
>    on the stack.
> 2. Use a union{} member for all of the case variables. This
>    tricks gcc into combining them all into a single stack
>    allocation. (There's also a comment on this)
>
>   

Applied all, thanks.

-- 
error compiling committee.c: too many arguments to function

