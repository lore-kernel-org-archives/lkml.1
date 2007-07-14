Return-Path: <linux-kernel-owner+w=401wt.eu-S1765720AbXGNU5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765720AbXGNU5W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 16:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763862AbXGNU5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 16:57:13 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:24702 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763695AbXGNU5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 16:57:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=GrB6FUBzVmCjw4NdsD5sHWFEDvl8QyJ6kMI+NP6bx55vFqFjGWzkdV/qhEMaWd1Pyd1+Kb3Vg5TrGpaW/e7Mgq4L1FWDf+XLEUgYT8ZThA2e/VyxXRDScTCmImZ9FzoNRurQ1FwMwekFef0ET593u9N5ZUbPlysoAtCO/daCaIo=
Message-ID: <76366b180707141357g39eca7a8p706f39a7a515719a@mail.gmail.com>
Date: Sat, 14 Jul 2007 16:57:11 -0400
From: "Andrew Paprocki" <andrew@ishiboo.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: Geode GX framebuffer driver: Arcom vs. AMD
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070714191854.GD13823@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <76366b180707141201u14585c2eyeb58f0b7b279ea1b@mail.gmail.com>
	 <20070714191854.GD13823@uranus.ravnborg.org>
X-Google-Sender-Auth: 5cfd28f837a8050f
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/14/07, Sam Ravnborg <sam@ravnborg.org> wrote:
> After a very brief look on the relevant part of the patch:
> -> Needs to be adapted to CodingStyle all over.

I agree, this can be done if it was ever going to be included.

> -> The use of AMD specific BUILDNUM etc are not used in-kernel

This can be cleaned up as well, or put behind some #ifdef to allow AMD
to keep using their own system, I suppose.

> -> The HAL in lib/cimarron needs to be justified - who are the oter users?

The HAL is used by the driver, obviously, but is included in
lib/cimarron for any other module writers which want to access the
graphics hardware from inside the kernel. When you're developing a
user app and want to access the hardware, you link Cimarron into your
code directly. I'm not sure what other kernel modules AMD expected to
be written, but I'm guessing they just wanted to keep their HAL and
write the framebuffer driver in terms of that instead of maintaining a
user-space HAL and a duplicate kernel driver.

> -> There seems to be a _lot_ of specific defines in lib/cimarron - I wonder
>    if this is the way used in the rest of the kernel?

Which defines are you referring to? I know there are a few 'settings'
which are modified by changing #defines in one of the .h files. I'm
assuming that those would be moved to Kconfig values if this was ever
in the kernel.

> But anyway - the patch it not trivially ready for inclusion.

I agree. I just did the work to port it from 2.6.11 to 2.6.22 just to
get it working in my tree. It all builds cleanly now, so any work
would most likely be cosmetic to clean up the code base.
