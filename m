Return-Path: <linux-kernel-owner+w=401wt.eu-S1757224AbYEORfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224AbYEORfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 13:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbYEORfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 13:35:05 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:51519 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbYEORfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 13:35:04 -0400
Date: Thu, 15 May 2008 19:35:39 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Michael Buesch <mb@bu3sch.de>,
       Gordon Farquharson <gordonfarquharson@gmail.com>
Subject: Re: crossbuild fails in modpost
Message-ID: <20080515173539.GA23959@uranus.ravnborg.org>
References: <482C3E3E.9090204@gmail.com> <482C6F02.1000205@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482C6F02.1000205@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 07:12:34PM +0200, Jiri Slaby wrote:
> Well, let's fix sam's email.
> 
> Jiri Slaby napsal(a):
> >Hi,
> >
> >probably
> >4ce6efed48d736e3384c39ff87bda723e1f8e041
> >kbuild: soften modpost checks when doing cross builds
> >
> >causes build failures on x86_64 kernel build on 32 bit machine:
> >
> >make -f /local/xslaby/hid/scripts/Makefile.modpost
> >YYYYYYYYYYYYYY x86_64 x86_64
> >  scripts/mod/modpost -m -a -o /local/xslaby/buhid/Module.symvers    -S 
> >-K /local/xslaby/buhid/Module.markers -M 
> >/local/xslaby/buhid/Module.markers   -s
> >XXXXXXXXXXXXXXXXXX 20: 0 (2), 4 (4), 8 (4), 12 (8)
> >FATAL: drivers/hid/hid-apple: sizeof(struct hid_device_id)=20 is not a 
> >modulo of the size of section __mod_hid_device_table=648.
> >Fix definition of struct hid_device_id in mod_devicetable.h
> >make[2]: *** [__modpost] Error 1
> >make[1]: *** [modules] Error 2
> >make: *** [sub-make] Error 2
> >
> >after sticking echo into:
> > __modpost: $(modules:.ko=.o) FORCE
> >+       @echo YYYYYYYYYYYYYY $(KBUILD_BUILDHOST) $(ARCH)
> >        $(call cmd,modpost) $(wildcard vmlinux) $(filter-out FORCE,$^)
> >

Your machine claims it is a x86_64 and you are building for a x86_64
according to the following line:
> >YYYYYYYYYYYYYY x86_64 x86_64

So it looks to me that you are building for 64 bit on a 64 bit machine.
So when you write:
 on x86_64 kernel build on 32 bit machine:

I assume you try to say that your HOSTCC is 32 bit and your
kernel cc is 64 bit (or something similar).

The commit you reference loosen up the check so we do not do the
check if we _know_ that the host and the target system differs.
The only thing I can imagine right now to solve your issue would
be to skip the check if we do not use the same gcc for target and host?

	Sam
