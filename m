Return-Path: <linux-kernel-owner+w=401wt.eu-S932999AbZADAha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932999AbZADAha (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 19:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755697AbZADAhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 19:37:18 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:56307 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbZADAhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 19:37:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=d5P0FPSCMISXVl2/UWdsuPRQw/AsSfJIxNRbnRkqDmydQzCgQ+nxD3p0JemFt9WQPe
         oAi9GF3qkxDduM4KqI6g7gL9fF6C4O9xYNEK0PPNg/Hr+6pRa9lAXskkmhoqCxVGhyYh
         x8CWSQPjL1/hjQXP0LdB14Zxf03scWDrHwCPQ=
Message-ID: <c384c5ea0901031637k3b571313m934c8881dce1c81@mail.gmail.com>
Date: Sun, 4 Jan 2009 01:37:12 +0100
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Cc: "Rob Landley" <rob@landley.net>,
       "Embedded Linux mailing list" <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Sam Ravnborg" <sam@ravnborg.org>
In-Reply-To: <495FEEAF.5020005@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200901020207.30359.rob@landley.net>
	 <c384c5ea0901031454n451bc899w166bb146c96f6164@mail.gmail.com>
	 <495FEEAF.5020005@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Jan 4, 2009 at 12:03 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Dependencies very quickly become dependency hell. If A requires B,
>> then A also inherits all (future) requirements of B, etc. etc.
>>
>> In my daily software development work with Linux and GNU software in
>> general, 10% of it is spent fighting/removing these extremely "thin"
>> or false depencies, so that it is usuable in embedded devices.
>>
>
> First of all, I largely consider this a joke.  All real-life embedded
> kernel builds take place on hosted platforms; anything else seems to be
> done "just because it can be done", as a kind of show-off art project.
> Cute, but hardly worth impeding the rest of the kernel community for.
>
Let me explain why it is not a joke for me, although yes I agree it's
a funny way of how software engineering works.

My argument on thin dependencies indeed mostly holds for run-time
dependencies (to reduce size) but also for build dependency (to reduce
complexity)*.

In general the right version of the right tool is not available on the
build host.

If I cross-build 30 packages all of which need a build-host-native
perl during their build, consider the chance of these packages
building with the one version of perl that lives on the system. It's
near 0% for the average mix of packages.

Yes, the host is fat enough so that we can build (say three) different
versions of perl to accomodate the build.

The truth often is, of the 30 build dependencies 25 of them are thin
(build) dependencies.

So yes, the say extra 10% of build tool dependency needed to make 0.5%
of the build system work, can be solved on the fat build platform, but
I do not always consider it a well engineered solution.

For a (dangerous) metaphor: In mechanical engineering, if there are 30
joints using nuts and bolts, and a 31st is designed in, it is strongly
prefered to make it a nut and bolt as well, even if using a screw
would work equally well or even better. The overall costs (over
complexity, tool dependency, maintainability) would be lower.

Regards,
-- 
Leon

* Since Intel, since recently, pays another team of excellent people
maintaining a system dealing with the (cross) build tool dependency
hell, I rest my case. :-)
