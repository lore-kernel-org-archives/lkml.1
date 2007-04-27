Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbXD0RcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbXD0RcQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 13:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756089AbXD0RcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 13:32:16 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:17967 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756088AbXD0RcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 13:32:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=h/R20y1IDzOpXEIoJ5VSnu6DsKb/IBsXnxyrTIgP25vvz9aZ1vdemDDz8aXznSjCDCPIuHij5kIVPnLPeJvZM+yPB5tHw+yumktpO6vFKmauWyGTY0DQ3qoQ250chliqepqRoqoiyr4L8tj697mSi9aqW6adZJirXnHKF+qqh/A=
Date: Fri, 27 Apr 2007 21:32:47 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ulrich Drepper <drepper@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       adobriyan@openvz.org
Subject: Re: [PATCH] v4: merged utimensat implementation
Message-ID: <20070427173247.GA5986@martell.zuzino.mipt.ru>
References: <200704271523.l3RFNwGN031209@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704271523.l3RFNwGN031209@devserv.devel.redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 11:23:58AM -0400, Ulrich Drepper wrote:
> I took Alexey's lutimes patches and merged it with the utimensat patch.
> Fortunately Alexey already did most of the work, the conversion to
> timespec.  I just changed the name of the syscall, made the flag part
> of the syscall parameters, and did away with the old do_utimes definition
> (the new do_utimes takes a timespec and a flag now).  All five patches
> patches are rolled into one.

erm, utime(2) cleanup is technically independent from all this nanosecond
business, but ok.

> --- a/arch/alpha/kernel/osf_sys.c
> +++ b/arch/alpha/kernel/osf_sys.c
> @@ -955,15 +955,25 @@ osf_setitimer(int which, struct itimerval32 __user *in, struct itimerval32 __use
>  asmlinkage int
>  osf_utimes(char __user *filename, struct timeval32 __user *tvs)
>  {
> -	struct timeval ktvs[2];
> +	struct timespec tv[2];

It should be tiny little bit nicer to call them "ts[2]" because they're
timeSpecs.

