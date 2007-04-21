Return-Path: <linux-kernel-owner+w=401wt.eu-S1752097AbXDUTqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbXDUTqi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 15:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbXDUTqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 15:46:38 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:6310 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbXDUTqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 15:46:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Wk2z8B7ObCY4WwP185Dp8i2sMrCqlwYd3oW0LeRlbWkdKnIa9Y1Yf3RIDzlZG6lprHvGVEsZyX+sOs7B3C1TTw2whBrEV+o20b5+zup1AIxvjYY7fMpvpUdOhq1+Ii4NvfASjFI0dRXxvK6Ee5TSzBX4wvIl+Nvdic9U1pCdQ68=
Message-ID: <a36005b50704211246x339415d1wcb9dac8c2239b692@mail.gmail.com>
Date: Sat, 21 Apr 2007 12:46:34 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Andreas Gruenbacher" <agruen@suse.de>
Subject: Re: [d_path 0/7] Fixes to d_path: Respin
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <200704212104.06349.agruen@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070412090809.917795000@suse.de>
	 <200704201840.07247.agruen@suse.de>
	 <a36005b50704201217l649195f0q204c2434445e7160@mail.gmail.com>
	 <200704212104.06349.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/21/07, Andreas Gruenbacher <agruen@suse.de> wrote:
> What I described is a supported feature, nothing more and nothing less. It's
> also relatively easy to handle this case correctly in glibc, e.g., [...]

This is only useful if the requirement of an ordered /proc/mounts is
part of the kernel ABI.  I.e., until somebody specifies (in the
sources, in kernel docs, I don't care where exactly) that the entries
in /proc/mounts appear in the order in which the mounts happened this
change is not better than the current code.  I have never found such
an assurance.


> This is what POSIX says about statvfs / fstatvfs:
> > It is unspecified whether all members of the statvfs structure have
> > meaningful values on all file systems.

Sure, just like POSIX in many other place leaves things unspecified.
This does not change the fact that we do a good job now.  You try to
use this wording to excuse the fact that you want to make the results
worse than they are now.  That's *not* the intend of this wording.


> In my opinion, the advantage of not reporting bogus pathnames in /proc/mounts
> by far outweighs the problems is sometimes causes for fstatvfs().

Hell no.  It is never acceptable to deliberately break compatibility.
Effects of bugs on the ABI might change but this is not the case here.
 This is an interface which forever displayed the information in this
form and it is correct and useful.
