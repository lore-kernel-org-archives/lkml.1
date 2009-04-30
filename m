Return-Path: <linux-kernel-owner+w=401wt.eu-S1761625AbZD3B46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761625AbZD3B46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 21:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbZD3B4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 21:56:48 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:39247 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbZD3B4q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 21:56:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=K+TbrVtg0DGxIQXsOPnMc8DWWDDyp/WtsAXccwj6bRGcdlUHAEC58DA0QbrkaDZdg2
         jonWCnTavrrQxgschxb1oiImUjccb0fCH+WTflOAwewOM1fb1kRItUpuFU4WH7GFSyri
         l222vA2/V+lfJn93x5lyJmQV9q5tv3YQxrCvM=
MIME-Version: 1.0
In-Reply-To: <1241056121.18530.31.camel@poy>
References: <20090427193532.GA2948@kroah.com>
	 <8bd0f97a0904291053g3aa71decpd33f6621ad0bf9f8@mail.gmail.com>
	 <20090429180735.GA29812@kroah.com>
	 <8bd0f97a0904291117ic07fadcs2a02fca3dcfefcf0@mail.gmail.com>
	 <ac3eb2510904291159s14d7d532q33657eb73007fc4b@mail.gmail.com>
	 <20090429192309.GA15539@kroah.com>
	 <44275.1241041373@turing-police.cc.vt.edu>
	 <20090429215623.GA27319@kroah.com> <1241056121.18530.31.camel@poy>
Date: Wed, 29 Apr 2009 21:56:45 -0400
Message-ID: <8bd0f97a0904291856n66fef7d8sb879e9e02b13a311@mail.gmail.com>
Subject: Re: usbutils 0.81 release
From: Mike Frysinger <vapier.adi@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, Valdis.Kletnieks@vt.edu,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 21:48, Kay Sievers wrote:
> On Wed, 2009-04-29 at 14:56 -0700, Greg KH wrote:
>> If youreally want it, you can grab it from the git tree, or wait a day
>> or so for me to implement Mike's changes he so nicely sent me, so I can
>> do a new release.
>
> How about this? It substitutes the script and the man page with the
> given --datadir=.

i had pretty much the same changes locally, but i was going to let the
discussion on data/multiple paths finish first.  at any rate, comments
below ...

> --- a/Makefile.am
> +++ b/Makefile.am
>
> +update-usbids.sh: update-usbids.sh.in
> +lsusb.8: lsusb.8.in

need $(srcdir)/ in front of the dependency

> +       sed 's|@usbids@|$(datadir)/usb.ids|' $< >$@
> +       sed 's|@usbids@|$(datadir)/usb.ids|' $< >$@

should use the 'g' option to sed

in theory you should use AC_PROG_SED in configure.ac and then $(SED)
in the Makefile.am

$(datadir) too should die ... $(datarootdir) is the right variable name

>  clean-local:
>        rm -f usb.ids.gz
> +       rm -f lsusb.8
> +       rm -f update-usbids.sh

after Greg merges the patches i sent for usb.ids.gz, it should be
clear that clean-local should die and you should update DISTCLEANFILES

> --- a/configure.ac
> +++ b/configure.ac
>
> +       datadir:                ${datadir}

we have datarootdir now, so no point in adding datadir
-mike
