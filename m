Return-Path: <linux-kernel-owner+w=401wt.eu-S1765279AbYEESra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765279AbYEESra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763296AbYEESgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:36:48 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:44782 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763278AbYEESgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:36:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=If6v/ECuGD4za+XeJldw+484qS4w3y42MsLxrQ9766qw8RJrJYqPA2DzCf+iSXC2Bcajkk+zsQJVT70nchmCMzZzaEOQvlZbJIIiO8TUXwuGpkmg1BDIFKjEkFgfPlXvpFB/MOyJWX9F7i9r/ooiJ6LgS2HE9n7NBS2giOAMdFo=
Message-ID: <ce0170d90805051136w2f016c15p575623d33c220ddf@mail.gmail.com>
Date: Mon, 5 May 2008 15:36:45 -0300
From: "Sergio Luis" <sergio@uece.br>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [PATCH] default to n for GROUP_SCHED and FAIR_GROUP_SCHED
Cc: "Ingo Molnar" <mingo@elte.hu>, "Parag Warudkar" <parag.warudkar@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "akpm@osdl.org" <akpm@osdl.org>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Dave Jones" <davej@redhat.com>
In-Reply-To: <20080505182427.GA2025@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <82e4877d0805031742o464dd581wd93173d79705ce0d@mail.gmail.com>
	 <20080504092417.GA3425@elte.hu>
	 <82e4877d0805050814j721ae522k84384df48c9f4336@mail.gmail.com>
	 <20080505171501.GA22332@elte.hu>
	 <20080505182427.GA2025@uranus.ravnborg.org>
X-Google-Sender-Auth: 65bc2d82757a98e1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 5, 2008 at 3:24 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Mon, May 05, 2008 at 07:15:01PM +0200, Ingo Molnar wrote:
>  >
>  > * Parag Warudkar <parag.warudkar@gmail.com> wrote:
>  >
>  > > sched-devel does not boot on my machine - stops right after PCI: Not
>  > > using mmconfig.
>  > >
>  > > Here is my config for sched-devel - I did a echo "n" | make oldconfig
>  > > after copying over the previous config file BTW. Should I try
>  > > disabling things in config? What's most likely to break boot? (Seems
>  > > likes there are a lot of significant changes in there.)
>  >
>  > every config is supposed to work, but in general you should pick the
>  > defaults instead of saying 'n' to all questions. As long as every
>  > question can be answered with an 'enter', this should work:
>  >
>  >   make oldconfig < /dev/null
>  >
>  > this non-interactive 'make oldconfig' will hang with the kconfig tool
>  > looping infinitely if there's any numeric question that cannot be
>  > answered via 'enter'.
>  >
>  > This is a many years old kconfig bug that is frequently hacked around in
>  > distro kernel packages but which has been ignored upstream - i've
>  > attached Fedora's nonint_oldconfig patch from Dave Jones below. (maybe
>  > Arjan wrote it originally?)
>
>  In latest kbuild.git I've added a new feature.
>
>         make K=.config alldefconfig
>
>  would give you eaxtly what you request here.
>  K= is used to say where to locate the base-configuration.
>
>  The above will give you a configuration based on your old configuration
>  with all new options set to default values.
>
>  That could maybe be more intuitive but when you consider it you
>  could have your base config in many different places.
>  Like /boot/config-xxx, /proc/config.gz etc.
>  So allowing the user to specify the base config with K= seems
>  like an acceptable solution.

Can I specify /proc/config.gz (gzipped) in the K parameter?
-sergio

>
>  Current version in kbuild.git is broken with respect to make O=...
>  builds but that will be fixed in an hour or so.
>
>  redhat has the added possibility to list new symbols.
>  This is not yet included in mainline.
>  Not that it is difficult - I just need to decide where/how to do it.
>
>         Sam
>
