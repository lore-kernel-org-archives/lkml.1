Return-Path: <linux-kernel-owner+w=401wt.eu-S965398AbXCQKxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965398AbXCQKxk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 06:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965419AbXCQKxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 06:53:40 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:37708 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965398AbXCQKxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 06:53:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Y0xAHGXarzttmOW9pYUnTfXSw+iVNlgBfBzJxHdOtt3MyLpDoFmodPWTktG3DFLYwG8cTAvU1bYNIEg+izeNgRItfvqVB9V8QotimykJDpL6u/cuUK/SgVJGtqDuhVdoK8jxP8rDsAtmUp23oT8/7FErFK5XYp5Wd+TWgrcURbY=
Message-ID: <84144f020703170353y4490d0dcr24352c291c96300b@mail.gmail.com>
Date: Sat, 17 Mar 2007 12:53:37 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: forced umount?
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <170fa0d20703162237m1023cbd2o8ccf9e464c53f4a0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <170fa0d20703162106v47dc13e1u1ae5381576f372ed@mail.gmail.com>
	 <45FB6E32.3050009@goop.org>
	 <170fa0d20703162237m1023cbd2o8ccf9e464c53f4a0@mail.gmail.com>
X-Google-Sender-Auth: 2c3563ec9e321b82
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/17/07, Mike Snitzer <snitzer@gmail.com> wrote:
> Thanks for the heads up; its good to see that Pekka Enberg's work has
> continued.  I actually stumbled onto that line of work earlier while
> searching for more info on Tigran Aivazian's forced unmount (badfs)
> patches:
> http://lwn.net/Articles/192632/

FYI, the revoke implementation have since been changed to follow the
badfs-style approach of the forced unmount patches. However, there are
some problems with the forced unmount patches that are now fixed in
the revoke implementation:

  - You can't use munmap() to take down shared memory mappings because the
    application can accidentally remap something completely different
to that region.
  - The ->f_light bits slow down other fget_light() users and  there's
a race between
    fcheck_files() and set_f_light().
  - The operation can live-lock if a malicious process keeps forking. The revoke
    implementation solves this by revoking in two passes: (1) take
down the descriptors
    and (2) take down the actual inodes.

                           Pekka
