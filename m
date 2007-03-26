Return-Path: <linux-kernel-owner+w=401wt.eu-S932697AbXCZVee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697AbXCZVee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 17:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932808AbXCZVee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 17:34:34 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:45929 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932697AbXCZVed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 17:34:33 -0400
Message-ID: <46083C79.1080108@cfl.rr.com>
Date: Mon, 26 Mar 2007 17:34:49 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Mike Snitzer <snitzer@gmail.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: forced umount?
References: <170fa0d20703162106v47dc13e1u1ae5381576f372ed@mail.gmail.com>  <45FB6E32.3050009@goop.org>  <170fa0d20703162237m1023cbd2o8ccf9e464c53f4a0@mail.gmail.com> <84144f020703170353y4490d0dcr24352c291c96300b@mail.gmail.com>
In-Reply-To: <84144f020703170353y4490d0dcr24352c291c96300b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Mar 2007 21:34:45.0761 (UTC) FILETIME=[92B56710:01C76FEE]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15078.001
X-TM-AS-Result: No--10.094800-5.000000-2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Is this revoke system supported for the filesystem as a whole?  I 
thought it was just to force specific files closed, not the whole 
filesystem.  What if the filesystem itself has pending IO to say, update 
inodes or block bitmaps?  Can these be aborted?

Pekka Enberg wrote:
> FYI, the revoke implementation have since been changed to follow the
> badfs-style approach of the forced unmount patches. However, there are
> some problems with the forced unmount patches that are now fixed in
> the revoke implementation:
> 
>  - You can't use munmap() to take down shared memory mappings because the
>    application can accidentally remap something completely different
> to that region.
>  - The ->f_light bits slow down other fget_light() users and  there's
> a race between
>    fcheck_files() and set_f_light().
>  - The operation can live-lock if a malicious process keeps forking. The 
> revoke
>    implementation solves this by revoking in two passes: (1) take
> down the descriptors
>    and (2) take down the actual inodes.
> 
>                           Pekka

