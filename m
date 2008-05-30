Return-Path: <linux-kernel-owner+w=401wt.eu-S1753615AbYE3Rpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbYE3Rpe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 13:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbYE3RpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 13:45:23 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:36210 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbYE3RpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 13:45:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=m3ci1tQUA3rJT01hcJxTiYmObGLiI6UPsYraEbtiAp9cb5Mz7Cv4x9lzGfDPkPXPbga383Px6rIloADq7g4nJbQ/f2PYvHvWyEaOJaxVKuupfBiNCMWxS/vrtYcrioX+/zB/2k9IcN9lqbR4/8QL2lxRonxnk3j+mlkDEEv/CM0=
Message-ID: <efc7ee340805301045q13e991a7y927a683b9c4f9acd@mail.gmail.com>
Date: Fri, 30 May 2008 10:45:12 -0700
From: Leonid <leonidv11@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [GIT PATCH] USB fixes for 2.6.26-rc4
Cc: "Greg KH" <gregkh@suse.de>, "David Brownell" <david-b@pacbell.net>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.0805292143001.26334-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080529215808.GA3759@suse.de>
	 <Pine.LNX.4.44L0.0805292143001.26334-100000@netrider.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Not to be overly pedantic, but you weren't so wrong to be confused on
the issue of "regression".  Here's the scoop:

1) Kernel versions <= 2.6.24: latency of 2/6/2/6/... uframes pattern
observed between packets on the bus for nVIDIA HCs.

2) Kernel versions >= 2.6.26: latency of 8/8/8/8/... uframes pattern
observed between packets on the bus for nVIDIA HCs.

3) Post-patch: latency of 1/1/1/1/... uframes on all kernels versions
and all HC chipsets.

So basically there was a peripheral issue in the EHCI driver between
2.6.24 and 2.6.25 that exacerbated the problem.  But the underlying
issue was there long before 2.6.25.  Dave is quite right that this
isn't technically a "regression."

The issue itself was a bug (as opposed to a "feature" ;-) ) since the
original comments in the code clearly had the right intention, but the
code itself did not execute as intended in certain situations.  In
fact, thinking about it now, this issue could even cause significant
performance degradation on nVIDIA HCs if one has multiple devices
using the bus at any given time.  Given this, it might be best to
label the patch "USB: EHCI: fix performance issue" instead of using
the word regression.  But regardless, we are just worrying about
symmantics at this point! :)

Hope that helps clarify and put to rest this titling issue once in for all.

-Leonid


On Thu, May 29, 2008 at 6:44 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 29 May 2008, Greg KH wrote:
>> Well, I was misinformed by Alan Stern about this then, sorry for missing
>> that you didn't ack this one (you acked the other patches in this series
>> though.)
>
> The notion that this was a regression came about by mistake.  It was
> stated that 2.6.24 worked better than 2.6.25; apparently that remark
> was wrong.
