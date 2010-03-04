Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160Ab0CDXfP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 18:35:15 -0500
Received: from mail-iw0-f175.google.com ([209.85.223.175]:32877 "EHLO
	mail-iw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713Ab0CDXfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 18:35:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=a/SEseBKBB4mH7Uai2W6y2nRIwJvpkCsFdESTQUBC7KlmdEh1A7CCwfYZFOTkXKwRw
         BQzk+VmEdmsKatstrBpW/TI3ViPtVcTNFFL2Bw9lv5nXcX2WSYK6pR4ixYekTxmxdwPH
         qFJ/PzPP3V2S1a/bVzRk8JRKsgz5x5gDfYilI=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1003041522570.3751@localhost.localdomain>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>
	 <20100304192524.GA24253@srcf.ucam.org>
	 <alpine.LFD.2.00.1003041131490.3751@localhost.localdomain>
	 <20100304195302.GA24856@srcf.ucam.org>
	 <alpine.LFD.2.00.1003041202240.3751@localhost.localdomain>
	 <6a89f9d51003041257j39fde3b6y8bd3336d77f7cf7a@mail.gmail.com>
	 <alpine.LFD.2.00.1003041449380.3751@localhost.localdomain>
	 <21d7e9971003041503p726ecbebi4b0b97854c5824de@mail.gmail.com>
	 <alpine.LFD.2.00.1003041507070.3751@localhost.localdomain>
	 <alpine.LFD.2.00.1003041522570.3751@localhost.localdomain>
Date: Fri, 5 Mar 2010 09:35:12 +1000
Message-ID: <21d7e9971003041535g9dbfe46k67f64aa4219da0b8@mail.gmail.com>
Subject: Re: [git pull] drm request 3
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephane Marchesin <stephane.marchesin@gmail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 5, 2010 at 9:28 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Thu, 4 Mar 2010, Linus Torvalds wrote:
>>
>> Is it really just nouveau? I've not looked, but I bet the intel driver and
>> the radeon driver have _exactly_ the same "oh, I'm the wrong version, I
>> will now kill myself" behavior.
>
> Ok, I cloned the drm tree just to see, and it does seem like it's just
> nouveau that does that whole thing. At least from a quick grep of
> drmGetVersion() calls.
>
>> I certainly seem to remember some similar issues with the intel driver
>> long long ago.
>
> .. but Jesse tells me that it's using feature masks etc, so maybe my
> recollection is about unrelated issues.
>
> So yeah, nouveau seems to "special". Although somebody already said that
> if I'd have had a radeon, I'd have seen similar issues. Maybe the radeon
> driver just doesn't check the version number, and fails in different ways.
>

As I mentioned earlier we had one issue with i810 about 7-8 years ago, before
I was here, someone changed the i810_drm.h api incompatibly in XFree86.
This was one of the things that led to having a proper policy.

For radeon while we were developing the KMS feature in staging we
changed the API
once or twice, while we were developing KMS in Fedora we changed it at least
4 times, we shipped Intel KMS in F9 with a completly different API and
just dealt
with it, since upstreaming changed the API completely.

The staging API changes were mostly to fix things that userspace did
that made it
possible to trample over other X users memory. This meant you had to bump the
userspace that was doing the evil thing by mistake.

Once we removed KMS from staging, we stabilised all APIs and behaviour
(its not just the API, internal command stream checking for security issues).

Since then we made one change to the CS behaviour in a backwards compatible
manner so that old userspaces wouldn't die, but you couldn't abuse the
hole they had relied on.

I'm not saying it doesn't happen in other drivers from time to time,
but when it does
its treated as regression, for nouveau and STAGING that isn't what the Nouveau
project (which Stephane mostly speaks for) seems to want at this stage.

Dave.
