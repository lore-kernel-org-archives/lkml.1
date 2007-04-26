Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870AbXDZRVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbXDZRVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754867AbXDZRVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:21:48 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:27684 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbXDZRVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:21:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jqMNlnyVQRmci9FNHTjxC9PyT8UVGAbW9Z7KyMJJNcs7ohud4ssOUgJyKICpAAX2uHS1YkjTs7jq81PIRJJMn1UtRNuiagPQi8mNomqiPcD43IfVQB4fHtfDEeFoQs6fstpeLn1degRS8NLCVMVbrVifjZidvn06q76UBJnsd5w=
Message-ID: <a44ae5cd0704261021n78780c71i4c8f7613d58dec54@mail.gmail.com>
Date: Thu, 26 Apr 2007 10:21:43 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: [PATCH] sysfs: use different lockdep subclass for s_active deactivation
Cc: "Andrew Morton" <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       greg@kroah.com
In-Reply-To: <20070426145047.GF17130@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0704242215w1b474c52r7860f0d49bc64d6c@mail.gmail.com>
	 <462EE4B7.6000708@gmail.com> <20070426145047.GF17130@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/26/07, Tejun Heo <htejun@gmail.com> wrote:
> A sysfs node can delete other sysfs files when accessed.  This results
> in recursive s_active locking - read lock for file access, down lock
> of the vicitim for deactivation.  Tell lockdep that it's okay.
>
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> ---
> Miles, please test this patch.  It should remove the lockdep warning.
> Fixes for the other two problems will soon follow.
>
> Greg, Andrew, after all the fixes are verified, I'll merge the fixes
> into the original patches and resend all the sysfs updates in better
> shape.  Sorry about all the trouble.

Should I test this with 2.6.21-rc7-mm2?
It doesn't apply cleanly.

# patch -p1 -l --dry-run < tejun.patch
patching file fs/sysfs/dir.c
Hunk #1 succeeded at 31 with fuzz 1 (offset -29 lines).
patching file fs/sysfs/sysfs.h
Hunk #1 succeeded at 40 (offset -1 lines).
Hunk #2 succeeded at 182 with fuzz 1 (offset -1 lines).
