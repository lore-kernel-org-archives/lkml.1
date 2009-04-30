Return-Path: <linux-kernel-owner+w=401wt.eu-S1761890AbZD3CHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761890AbZD3CHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 22:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757193AbZD3CHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 22:07:15 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:42848 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273AbZD3CHO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 22:07:14 -0400
MIME-Version: 1.0
In-Reply-To: <8bd0f97a0904291856n66fef7d8sb879e9e02b13a311@mail.gmail.com>
References: <20090427193532.GA2948@kroah.com> <8bd0f97a0904291053g3aa71decpd33f6621ad0bf9f8@mail.gmail.com> 
	<20090429180735.GA29812@kroah.com> <8bd0f97a0904291117ic07fadcs2a02fca3dcfefcf0@mail.gmail.com> 
	<ac3eb2510904291159s14d7d532q33657eb73007fc4b@mail.gmail.com> 
	<20090429192309.GA15539@kroah.com> <44275.1241041373@turing-police.cc.vt.edu> 
	<20090429215623.GA27319@kroah.com> <1241056121.18530.31.camel@poy> 
	<8bd0f97a0904291856n66fef7d8sb879e9e02b13a311@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 30 Apr 2009 04:06:53 +0200
Message-ID: <ac3eb2510904291906v6b8524f7j5cb3afa43f6759b8@mail.gmail.com>
Subject: Re: usbutils 0.81 release
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Greg KH <greg@kroah.com>, Valdis.Kletnieks@vt.edu,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 03:56, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On Wed, Apr 29, 2009 at 21:48, Kay Sievers wrote:
>> On Wed, 2009-04-29 at 14:56 -0700, Greg KH wrote:
>>> If youreally want it, you can grab it from the git tree, or wait a day
>>> or so for me to implement Mike's changes he so nicely sent me, so I can
>>> do a new release.
>>
>> How about this? It substitutes the script and the man page with the
>> given --datadir=.
>
> i had pretty much the same changes locally, but i was going to let the
> discussion on data/multiple paths finish first.  at any rate, comments
> below ...
>
>> --- a/Makefile.am
>> +++ b/Makefile.am
>>
>> +update-usbids.sh: update-usbids.sh.in
>> +lsusb.8: lsusb.8.in
>
> need $(srcdir)/ in front of the dependency
>
>> +       sed 's|@usbids@|$(datadir)/usb.ids|' $< >$@
>> +       sed 's|@usbids@|$(datadir)/usb.ids|' $< >$@
>
> should use the 'g' option to sed
>
> in theory you should use AC_PROG_SED in configure.ac and then $(SED)
> in the Makefile.am

Fine, if that works.

> $(datadir) too should die ... $(datarootdir) is the right variable name

Then you want to specify man pages separately? I wouldn't do that.

>>  clean-local:
>>        rm -f usb.ids.gz
>> +       rm -f lsusb.8
>> +       rm -f update-usbids.sh
>
> after Greg merges the patches i sent for usb.ids.gz, it should be
> clear that clean-local should die and you should update DISTCLEANFILES

Sure, no problem.

>> --- a/configure.ac
>> +++ b/configure.ac
>>
>> +       datadir:                ${datadir}
>
> we have datarootdir now, so no point in adding datadir

Only if you require to set the man dir.

Kay
