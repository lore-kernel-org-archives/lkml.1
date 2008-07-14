Return-Path: <linux-kernel-owner+w=401wt.eu-S1755213AbYGNRG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbYGNRG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 13:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbYGNRGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 13:06:50 -0400
Received: from rn-out-0910.google.com ([64.233.170.186]:26787 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbYGNRGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 13:06:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=B0UW69e0IXnfWkEcQjQs6W5VO88lZHoW4uL4IE5QszTQXrM9x7y0BkmudRqJmGBDE4
         fZno4S5DQecFAfRM0vD3HvO664NlbvOlK4nGHRdEpBA6wtjvckFE8ioWhGuGD3kw9g4N
         snTRW6FamvSA6Wl8gTaV7xVgjGUPsRzDZpK68=
Message-ID: <86802c440807141006o98afac8t66b0933d8acd2746@mail.gmail.com>
Date: Mon, 14 Jul 2008 10:06:48 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Find offset for crashkernel reservation automatically
Cc: "Bernhard Walle" <bwalle@suse.de>, "Vivek Goyal" <vgoyal@redhat.com>,
       kexec@lists.infradead.org, x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <m1od50ztoa.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214510048-21215-1-git-send-email-bwalle@suse.de>
	 <20080627133256.GB5801@redhat.com>
	 <86802c440807140011v728cc35fy2540b537ddca9844@mail.gmail.com>
	 <20080714112404.36783df5@halley.suse.de>
	 <m1od50ztoa.fsf@frodo.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2008 at 2:44 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Bernhard Walle <bwalle@suse.de> writes:
>
>> * Yinghai Lu [2008-07-14 00:11]:
>>>
>>> should use min_t(u64, 1ULL<<32, max_low_pfn<<PAGE_SHIFT) replace ULONG_MAX
>>
>> Shouldn't we use  min_t(u64, ULLONG_MAX, max_low_pfn<<PAGE_SHIFT), i.e.
>> should we really limit the crashkernel to a 32 bit address on a 64 bit
>> system?
>
> We should use the lowest physical address that meets our size and
> alignment constraints.  However there is no reason to make this be <
> 4G or even < 1G.  The worst case is that we reserve an area the kdump
> kernel can't run out of.  However /sbin/kexec should check for that as
> the kexec on panic code is not necessarily a linux kernel.

for 64bit, kdump can start from address above 4g with bzImage?

YH
