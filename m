Return-Path: <linux-kernel-owner+w=401wt.eu-S1755649AbYDIVV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649AbYDIVV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 17:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbYDIVVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 17:21:22 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:41281 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbYDIVVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 17:21:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Rk2oK3EQefdYhF+WdNeACl3Bxg98SxE0rGjGKLrJWulesN610W8b0QGquvf+U0YTmH0vj8BViKFxCanEJZxiMpFnP3w+V0+ff6Vy9RENPEw/ZgLqzSXZoDjEZ0/Z8qHzPcSST1zCTeBq3hVrJCzTMPUgvDDIaPhlCbA1Q6H06ac=
Message-ID: <36ca99e90804091421g5b5a2cc9xc25e0db5428e3b12@mail.gmail.com>
Date: Wed, 9 Apr 2008 23:21:20 +0200
From: "Bert Wesarg" <bert.wesarg@googlemail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [PATCH 0/3] x86: add cpus_scnprintf function v3
Cc: "Mike Travis" <travis@sgi.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Paul Jackson" <pj@sgi.com>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080409211411.GA11120@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080408184301.651388000@polaris-admin.engr.sgi.com>
	 <36ca99e90804091051k7c2cc97neba0ca1967625433@mail.gmail.com>
	 <20080409203909.GA17183@suse.de>
	 <36ca99e90804091352g4910fc6cr2d23279324e12cf1@mail.gmail.com>
	 <20080409211411.GA11120@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 9, 2008 at 11:14 PM, Greg KH <gregkh@suse.de> wrote:
>
> On Wed, Apr 09, 2008 at 10:52:58PM +0200, Bert Wesarg wrote:
>  > On Wed, Apr 9, 2008 at 10:39 PM, Greg KH <gregkh@suse.de> wrote:
>  > >
>  > > On Wed, Apr 09, 2008 at 07:51:23PM +0200, Bert Wesarg wrote:
>  > >  > On Tue, Apr 8, 2008 at 8:43 PM, Mike Travis <travis@sgi.com> wrote:
>  > >  > >   * Cleanup usages of cpumask_scprintf in the following files and add
>  > >  > >     another interface to use cpulist_scnprintf where appropriate.
>  > >  >
>  > >  > On Mon, Apr 7, 2008 at 8:22 PM, Mike Travis <travis@sgi.com> wrote:
>  > >  > >  Part of the change is readability, but also looking towards the future
>  > >  > >  of 16k/64k/??? # of cpus, the straight mask approach will overflow the
>  > >  > >  PAGE_SIZE buffer provided (though some pathological cases will overflow
>  > >  > >  the range method as well.)  So we'll need some advancement in the format
>  > >  > >  of the printout.
>  > >  >
>  > >  > Btw, I think you can now push for a deprecation of the 'old' mask
>  > >  > attributes, with the justification you have given above. The other
>  > >  > possibility is to change sysfs to provide bigger attribute buffers
>  > >  > (CCed Greg for this).
>  > >
>  > >  Huh?
>  > >
>  > >  sysfs is "one value per file", if you are getting close to PAGE_SIZE in
>  > >  any sysfs file, then you are doing something very wrong.
>  > >
>  > >  What sysfs file currently is trying to output data this big?
>  > Currently none. But if NR_CPUS >= 16K and PAGE_SIZE == 4K, than any
>  > file with an cpumask_scnprintf().
>
>  Do we have such sysfs files today?
Files with cpumask_scnprintf()? Sure, the cpu topology exports plenty
of cpu masks.

If you ask for files with that big NR_CPUS, than no. We are talking
only for future scenarios.

Bert
>
>  thanks,
>
>  greg k-h
>
