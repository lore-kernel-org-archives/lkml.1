Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbZKEEAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbZKEEAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 23:00:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbZKEEAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 23:00:12 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:50211 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbZKEEAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 23:00:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=P26byGIKD0Q+jOWNHVZhN6DvvKCqeLEEeHwC/EuOioDNtkf1DdQ8sWaxcRAq/NUYjg
         mDtsi+1E8viD8GpVZKZwz0tOh8j+E3vInNGCxZcxv+ZFHx17enDE7SPNLlIuFIxve2fl
         Xn7g2OETcYNcT1bFdc+ELe5LKphpZLnwZv4Jo=
MIME-Version: 1.0
In-Reply-To: <cb0375e10910301155s5e2b2e79t562bfa798ba75e23@mail.gmail.com>
References: <cb0375e10910030939v8d03df7m861a2f05219f173c@mail.gmail.com>
	 <cb0375e10910030950kcd19fe9i7835eaaf4314c0fb@mail.gmail.com>
	 <20091005092148.4341d9ab@jbarnes-g45>
	 <cb0375e10910072044m470c8cbasef33de3b36bb62ee@mail.gmail.com>
	 <20091029094723.7e5a3376@jbarnes-g45>
	 <cb0375e10910291022l5650994dyc4a36d55f1e5bbc4@mail.gmail.com>
	 <cb0375e10910291040i31a7b9aatb6da5c20778d9791@mail.gmail.com>
	 <cb0375e10910292325l659034c4u36cf263cda8e90c8@mail.gmail.com>
	 <20091030083742.48f5d4f3@jbarnes-g45>
	 <cb0375e10910301155s5e2b2e79t562bfa798ba75e23@mail.gmail.com>
Date: Wed, 4 Nov 2009 23:00:14 -0500
X-Google-Sender-Auth: c2878e895f2f4f00
Message-ID: <cb0375e10911042000h3cf215a1o44add74510c15a1c@mail.gmail.com>
Subject: Re: [resend] i915: high power consumption after suspend/resume
From: Andrew Lutomirski <luto@mit.edu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's some more info.  I write a little script:

#!/bin/sh

for ((i=0; $i < 15; i=$i+1)); do cat
/sys/class/power_supply/BAT0/power_now; sleep 1 ; done

echo 'Wedging'
echo 1 > /sys/kernel/debug/dri/0/i915_wedged

for ((i=0; $i < 15; i=$i+1)); do cat
/sys/class/power_supply/BAT0/power_now; sleep 1 ; done

I triggered the high power consumption twice today.  I logged out of
X, logged into a console, and ran the script each time.  (The first
time, I did 10 iterations, not 15.)  Here are the results:

9586000
9574000
9574000
9586000
9586000
9574000
9574000
9629000
9629000
9607000
Wedging
9607000
9614000
9614000
9173000
9173000
8775000
8775000
8535000
8535000
8341000

and

9080000
9080000
9022000
9022000
9112000
9112000
9100000
9100000
9100000
9100000
9123000
9123000
9112000
9112000
9135000
Wedging
9135000
9053000
9053000
8618000
8618000
8309000
8309000
8056000
8056000
7861000
7861000
7712000
7712000
7643000
7643000

so it looks like it's not a register setting after all.  Maybe my BIOS
leaves the renderer in some weird state.

--Andy
