Return-Path: <linux-kernel-owner+w=401wt.eu-S1757653AbYDGMnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653AbYDGMnp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 08:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbYDGMnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 08:43:35 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:6117 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbYDGMne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 08:43:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=HBjdy9YlGCoDhFv+cuRk4ZRhai/bFFv44D/0PKl7Wpw9c93EkzBUgRzvSyQ44x2av5FBSy8E9eGiEAxOF1XRpHZASb7rpaUm4oitvmQI3ITuicVKAId/+0yREm1+q8+pykTSg/cCO3bn+6H+T8RVVMvnITeqptPIaH+ug+ehVQ0=
Message-ID: <47FA16DA.80700@gmail.com>
Date: Mon, 07 Apr 2008 21:43:06 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dan Williams <dan.j.williams@intel.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, neilb@suse.de
Subject: Re: [RFC PATCH] sysfs: refill attribute buffer when reading from
 offset 0
References: <20080405184122.2816.35845.stgit@dwillia2-linux.ch.intel.com> <20080405232959.c6504be8.akpm@linux-foundation.org>
In-Reply-To: <20080405232959.c6504be8.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Andrew Morton wrote:
>>  The application for this change is to allow a userspace
>> RAID metadata handler to check the state of an array without causing any
>> memory allocations.  Thus not causing writeback to a raid array that might
>> be blocked waiting for userspace to take action.
> 
> Although that sounds like a rather, umm, optimistic application.  I guess
> if everything's mlocked you might get lucky.
> 
>> Cc: NeilBrown <neilb@suse.de>
>> Cc: Tejun Heo <htejun@gmail.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Acked-by: Tejun Heo <htejun@gmail.com>

> Has this been tested with pread()?  That should work - doing an lseek+read
> is plain dopey.
> 
> Can we now remove need_read_fill?  Not if we want to support
> open+lseek+read, I guess - this initial read might not be at offset
> zero.

Heh.. needs_read_fill is set after read and poll regardless of file pos 
and I bet there are applications depending on it.  :-(

-- 
tejun
