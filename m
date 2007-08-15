Return-Path: <linux-kernel-owner+w=401wt.eu-S932448AbXHOPa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448AbXHOPa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 11:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760963AbXHOPaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 11:30:18 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:59709 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756775AbXHOPaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 11:30:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=R4ImZCi8ldLlqYfsBPmJYW6XdwokUPwT43tlnO5glaEOOdho/t0eLYJBIJhfLVfPuobxVj08F6pjaGWxiIvROqSdNybV1LvBCkCYflLJplfCibHgY1ylPoq/FP7qM5jDpEBifq18bp8Q4FfPf0noBTSttR+tHc9tag7p6m435rw=
Message-ID: <46C31BFB.6040702@gmail.com>
Date: Thu, 16 Aug 2007 00:30:03 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: Alan Stern <stern@rowland.harvard.edu>, Florin Iucha <florin@iucha.net>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       "Randy. Dunlap" <rdunlap@xenotime.net>
Subject: Re: [linux-usb-devel] USB-related oops in sysfs with linux v2.6.23-rc3-50-g28e8351
References: <Pine.LNX.4.44L0.0708151033270.3895-100000@iolanthe.rowland.org>	<46C313B3.4030700@gmail.com> <20070815172133.4f2eeda8@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070815172133.4f2eeda8@gondolin.boeblingen.de.ibm.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck wrote:
> On Wed, 15 Aug 2007 23:54:43 +0900,
> Tejun Heo <htejun@gmail.com> wrote:
> 
>> Alan Stern wrote:
>>> I think we can simply remove the error message.  There's no obvious 
>>> reason why sysfs_remove_bin_file() should complain about attempts to 
>>> remove a nonexistent file; sysfs_remove_file() doesn't.
>>>
>>> This patch will get rid of the annoying error messages.  It won't do 
>>> anything about your keyboard's tendency to spontaneously stop working, 
>>> alas.
>> Agreed but I think sysfs_remove_bin_file() should relay the return value
>> from sysfs_has_and_remove() to the caller.
> 
> Three comments:
> 
> - Randy made sysfs_remove_bin_file() return void in commit
> 995982ca79d9262869513948ec7c540f32035491.
> 
> - For symmetry reasons, sysfs_remove_file() should then also pass the
> return value on.
> 
> - I'm not sure who wants to care whether they removed an existing or
> non-existing file. But maybe I'm just unimaginative.

Hmmm... Well, failure information is lost there, so I was a bit worried.
 It probably doesn't really matter and can be easily changed later if
needed.  If sysfs_remove_file() returns void, I have no objection.

Thanks.

-- 
tejun
