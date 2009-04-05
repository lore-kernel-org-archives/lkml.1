Return-Path: <linux-kernel-owner+w=401wt.eu-S1757355AbZDEHn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbZDEHn7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 03:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757305AbZDEHnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 03:43:46 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:55002 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbZDEHnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 03:43:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pCwqzPXg9vVjpGTW82OHRFbyuFk2WvjRInT3ESF9tfG/MzthQxL6QiIQwrmxshASdf
         nVP/0VcqvOyeM/dIjSrRi71OUwysIbNbXVGFzyM6s+ZBYT/2EmBkmgTDul5UpV6M41hA
         fXyZbN7K5oNdl6bfZfmTCTZXA8ERIWxpiCObo=
MIME-Version: 1.0
In-Reply-To: <1227567739.6421.44.camel@localhost>
References: <1227454026.7262.59.camel@localhost> <492A7632.4040106@compton.nu>
	 <200811241613.25557.trenn@suse.de> <200811241736.53067.trenn@suse.de>
	 <1227567739.6421.44.camel@localhost>
Date: Sun, 5 Apr 2009 09:43:40 +0200
Message-ID: <71cd59b00904050043u44d1cd2eu4b8d3aee9027ea17@mail.gmail.com>
Subject: Re: [Acpi4asus-user] [PATCH 1/1] cpufreq: eeepc 900 frequency scaling 
	driver
From: Corentin Chary <corentin.chary@gmail.com>
To: Cristiano Prisciandaro <cristiano.p@solnet.ch>
Cc: Thomas Renninger <trenn@suse.de>, Dave Jones <davej@redhat.com>,
       acpi4asus-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       cpufreq@vger.kernel.org, Tom Hughes <tom@compton.nu>,
       linux acpi <linux-acpi@vger.kernel.org>,
       Francesco Lattanzio <f.lattanzio@simail.it>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Grigori Goronzy <greg@chown.ath.cx>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Could it happen that upcoming machines provide this interface (the two ACPI
>> functions) and also can do real CPU frequency/volt switching, e.g. via
>> acpi-cpufreq?
>
> Probably this interface is a solution specific to machines based on the
> celeron M: I don't even know if other 'old' models provide the same
> interface.

Hi,
We I just received another patch for that (adding a cpufv file in
sysfs) and I don't really know what to do.

As Grigori Goronzy said, using cpufreq in not a good idea:

> 1) dynamic governors like "ondemand" or "conservative" are not suitable
> for SHE. It's possible to avoid usage of these by specifying a long
> (e.g. UINT_MAX) transition latency. However, the fallback governor is
> "performance" which isn't a good idea either, because it'll use the
> overclock setting always. For SHE, the default should be the "normal",
> non-overclocked frequency.
>
> 2) The SHE ACPI interface doesn't expose the clock frequencies. I'm
> using 750 / 1000 / 1500 KHz at the moment, but that's hacky. cpufreq
> does not support performance points with names, such as "powersave",
> "normal", "performance", etc.
>
> 3) It looks like it is impossible to use more than one cpufreq driver
> per CPU. This effectively means you can either use the regular ACPI
> frequency scaling, which switches between multipliers, or SHE. That's
> unacceptable. SHE is not intended to replace the regular frequency
> scaling, but to complement it.

But adding another specific file for eeepc seems ugly too.
Does someone have a great idea to solve that ?

Thanks
-- 
Corentin Chary
http://xf.iksaif.net
