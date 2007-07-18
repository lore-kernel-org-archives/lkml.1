Return-Path: <linux-kernel-owner+w=401wt.eu-S933902AbXGRQIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933902AbXGRQIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 12:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760561AbXGRQIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 12:08:42 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:5826 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760397AbXGRQIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 12:08:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aPUtBeZ4QqVBV4JjwmWDTO/pV9x7ZqvWRCm8s5XwhPUqgzok+IGNrEtSZ42dygNrGEQSMsV2WLOy1vZoTggiR3yHUsCmUlfaTM4OMqCPVxgbmujgLzXZMJ/uT6XM8pTJIg8/tamxkHBVg020oz8rAm9DeJ8VyLKCg7U7jV26ErA=
Message-ID: <a781481a0707180908o68102680o5590722127ba9b02@mail.gmail.com>
Date: Wed, 18 Jul 2007 21:38:40 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: [PATCH] sysfs: kill an extra put in sysfs_create_link() failure path
Cc: "Gabriel C" <nix.or.die@googlemail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Christoph Lameter" <clameter@sgi.com>, gregkh@suse.de,
       miles.lane@gmail.com
In-Reply-To: <469E3786.4090409@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a781481a0707142239l397672c6p4fd1dc8dfb73e07c@mail.gmail.com>
	 <469BB9CA.6090500@googlemail.com> <469BC2D6.5090008@googlemail.com>
	 <469BC34C.4080107@googlemail.com>
	 <20070718071445.GI23568@htj.dyndns.org>
	 <a781481a0707180748j4760ab8bo237c1abc02feb593@mail.gmail.com>
	 <469E2A68.6010307@gmail.com>
	 <a781481a0707180816r478d2512v953036a1e4145a72@mail.gmail.com>
	 <a781481a0707180830g44cdd38etb4a540afce218065@mail.gmail.com>
	 <469E3786.4090409@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/18/07, Tejun Heo <htejun@gmail.com> wrote:
> Satyam Sharma wrote:
> > A trivial nit:
> >
> > The cleanup ignores the return of sysfs_addrm_finish() -- functions
> > such as those could and should be void-returning. It doesn't even
> > need to return an int for success / failure ... I went over it's code,
> > and it's obvious that the function just never fails!
> >
> > Returning the count of objects actually added / removed is quite
> > redundant too, because we return "actx->cnt" unconditionally
> > from inside it, and the caller can know that anyway, without
> > even calling it. Also, note that nowhere in the present code is
> > the return of that function ever being used in that sense (i.e. as
> > a "count") anyway ...
> >
> > So: best to just make it void-returning. That's what it is.
>
> Oh well, the function was made that way because that made the conversion
> easier when add/rm paths were consolidated using sysfs_addrm_cxt and
> friends.  So, if you see the detail as a problem, please submit a patch.
>  I dunno whether I would agree with the patch or not without seeing one.

Ok, I'll submit one then.

Thanks,
Satyam
