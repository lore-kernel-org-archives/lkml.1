Return-Path: <linux-kernel-owner+w=401wt.eu-S1755302AbYIWSPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302AbYIWSPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 14:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbYIWSPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 14:15:24 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:5609 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbYIWSPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 14:15:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=KFjAvb7fdf/aKGhbUl5eH1Fkt5yKYN7AnFcFtErbjMpYKuFlzYxOnoG6fqMvwbcLNk
         K1fBXFYoEVgNq9++43s0VOjkJ7pi2zsf5dSQgqfa0M7Bw5F4BlbXMx9Bv79vfNZFC0q9
         bg0i84F9sNCUOLicGsejiehiADFR0BILLrWL0=
Message-ID: <70318cbf0809231115r506db98etd87b67a590ba6eae@mail.gmail.com>
Date: Tue, 23 Sep 2008 11:15:19 -0700
From: "Chris Li" <lkml@chrisli.org>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: diet-kconfig: a script to trim unneeded kconfigs
Cc: "Giacomo A. Catenazzi" <cate@cateee.net>,
       "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       "Steven Rostedt" <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
In-Reply-To: <s5hr67bumiq.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <s5hbpyny7bl.wl%tiwai@suse.de>
	 <20080918122541.2c3c7b39@areia.chehab.org>
	 <48D27734.3040600@cateee.net>
	 <alpine.LFD.1.10.0809181154020.12224@bombadil.infradead.org>
	 <48D36D02.4090003@cateee.net> <s5hy71oyviu.wl%tiwai@suse.de>
	 <70318cbf0809191655m89e4b4fo68c3693487afed98@mail.gmail.com>
	 <s5hk5d4xzw0.wl%tiwai@suse.de>
	 <70318cbf0809221225i5be0ce6eh3ac09d8bf61cc2d7@mail.gmail.com>
	 <s5hr67bumiq.wl%tiwai@suse.de>
X-Google-Sender-Auth: 6e403b3056ccd8b4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 4:31 AM, Takashi Iwai <tiwai@suse.de> wrote:
> That is true.  Enabling arbitrary kernel config item is hard to
> achieve right now.  I think this feature should be implemented in
> kbuild parser itself.  The current reverse-select is way limited and
> known to be problematic in many kernel configs.

I was looking at the kbuild system. BTW, I really like the Makefile
in kbuild.  For the reverse select, here is what I have in mind.

The reverse select needs to maintain the define-user chain for
each kernel option. And each kernel option has a list of the kernel
option and value pare to enable an option. Once we produce such
an list for "all config". We can know exactly what kernel option
needs to set in order to get to so module. It is kind of doing
the data flow analyze on the config options.

It is not trivial, but it shouldn't be too hard either.

> Anyway, I think the white list isn't that hard for certain use-cases.
> My assumption is that users base on the distro kernel that have
> already all modules.  Then, for likely scenarios such as USB-storage
> hotplug, we can simply provide possible modules such as usb-storage
> and nls_* as the additional modules.  The script would just need to
> add them to the existing module list.  If necessary, the module
> dependency can be solved easily from modules.dep, too.

If you just want a white list without resolving the dependency, that
should be very easy to do in my current minmod.py.

In terms of implement in C. The currently kconf symbol has most
of the bits ready already. We can add a symbol type "module".
It points to a list of config symbols. That should be good enough.
Then we can use 1 bit of flag in config symbol to mark it is blacklisted
or not.

We can use some thing like minmod.py to provide a prototype
for some kernel user to try it out. If it covers most of the feature
the we want. We can go ahead to the C version.

> But not about this case.  It wants to be compiled-in, too.

I think my script can catch those already. Maybe I will beat it
up to generate a list of similar configs using "obj-m" directly.
We can example them one by one.

Chris
