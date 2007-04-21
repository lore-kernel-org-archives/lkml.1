Return-Path: <linux-kernel-owner+w=401wt.eu-S1030310AbXDUKyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030310AbXDUKyu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 06:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030673AbXDUKys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 06:54:48 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:15084 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030651AbXDUKyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 06:54:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AgHlSiIWWj9YPNmy1yLdbItJGrCt0B2VYkHJc5NJX8xmUlsjk/AGtg8rDoSW6l6Sq3xxXi588QFUetMkq36cctvvM//7ObNXk5sM6ZDogcYlplZ1a5xsV5WASYKVgGuCHV68Xaa4yEnfYeFht8in/gC7aAA6eFoL28pvs6hKQQk=
Message-ID: <62eb359a0704210354t26164b39tc8a842cf598f1927@mail.gmail.com>
Date: Sat, 21 Apr 2007 05:54:46 -0500
From: "Marcos Pinto" <markybob@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: 2.6.20.7 locking up hard on boot
Cc: "Greg KH" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       "Jan Beulich" <jbeulich@novell.com>, "Alan Cox" <alan@redhat.com>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       linux-pci@atrey.karlin.mff.cuni.cz
In-Reply-To: <20070421103632.GC4016@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <62eb359a0704201747ma376567kda671d6fa98b7409@mail.gmail.com>
	 <20070421013454.GB4016@stusta.de>
	 <62eb359a0704202130p39cf24efu89dccc8437c30d25@mail.gmail.com>
	 <20070421053420.GA10974@suse.de> <20070421103632.GC4016@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It took me several hours, but I just got done combing things over with
bisect as Greg requested.  This is what git spit out as the problem
patch in the end:

7639e962234c76031d1ddf436def7fd9602be560 is first bad commit
commit 7639e962234c76031d1ddf436def7fd9602be560
Author: Jan Beulich <jbeulich@novell.com>
Date:   Tue Mar 13 14:04:11 2007 -0400

    adjust legacy IDE resource setting (v2)

    adjust legacy IDE resource setting (v2)

    The change to force legacy mode IDE channels' resources to fixed non-zero
    values confuses (at least some versions of) X, because the values reported
    by the kernel and those readable from PCI config space aren't consistent
    anymore.  Therefore, this patch arranges for the respective BARs to also
    get updated if possible.

    Signed-off-by: Jan Beulich <jbeulich@novell.com>
    Acked-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
    Cc: Chuck Ebbert <cebbert@redhat.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

:040000 040000 d4ee6822208dc3e205bfc92fd30121e7894e63a9
5155044aa75f0d2671e7f5081f5b2999f24034bd M      drivers
bisect run success


Please let me know if there's more that I can do.
Thank you,
Marcos

On 4/21/07, Adrian Bunk <bunk@stusta.de> wrote:
> On Fri, Apr 20, 2007 at 10:34:20PM -0700, Greg KH wrote:
> > On Fri, Apr 20, 2007 at 11:30:59PM -0500, Marcos Pinto wrote:
> > >  Yes, I just tried 2.6.20.3 with ACPI enabled and it booted perfectly.
> > >  I'm hoping this means you know what's wrong? :-)
> >
> > Can you do a 'git bisect' on the versions between 2.6.20.3 and 2.6.20.7
> > to try to find the problem patch?
>
> Considering where it failed and that 2.6.20.3 worked, I would be
> extremely surprised if this wasn't one more report of
> adjust-legacy-ide-resource-setting.patch breaking booting (and we
> already have confirmed reports for this)...
>
> But AFAIK we still don't understand how this patch managed to break
> things.
>
> > thanks,
> >
> > greg k-h
>
> cu
> Adrian
>
> --
>
>        "Is there not promise of rain?" Ling Tan asked suddenly out
>         of the darkness. There had been need of rain for many days.
>        "Only a promise," Lao Er said.
>                                        Pearl S. Buck - Dragon Seed
>
>
