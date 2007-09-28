Return-Path: <linux-kernel-owner+w=401wt.eu-S1753497AbXI1Qlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbXI1Qlg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 12:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbXI1Ql3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 12:41:29 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:54811 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbXI1Ql2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 12:41:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=e9Cu2fCW5PMR0vHkuYB0btSRcUpynxPMRakc2qaMW00Bm+xQskOvWQH++JkW8vHGFhTS+ZU0Ue1lXx4dgV+s20a4f/nrebG2nmMkqJPv5amKFhvAhqIoaUlVtAF4sKHKhT24Sksf97dgKPYwjPRI729tssaeJJThuD7Sq5JfsB4=
Message-ID: <19f34abd0709280941o3183d39cn5b29d90636ef1035@mail.gmail.com>
Date: Fri, 28 Sep 2007 18:41:27 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Rob Landley" <rob@landley.net>
Subject: Re: [RFC] New kernel-message logging API (take 2)
Cc: LKML <linux-kernel@vger.kernel.org>, "Kyle Moffett" <mrmacman_g4@mac.com>,
       "Michael Holzheu" <holzheu@linux.vnet.ibm.com>,
       "Joe Perches" <joe@perches.com>,
       "Dick Streefland" <dick.streefland@altium.nl>,
       "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>,
       "Jesse Barnes" <jesse.barnes@intel.com>,
       "Arnd Bergmann" <arnd@arndb.de>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Emil Medve" <Emilian.Medve@freescale.com>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>,
       "linux@horizon.com" <linux@horizon.com>
In-Reply-To: <200709281130.26124.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0709271418l471cf7b9gf24161190772fac@mail.gmail.com>
	 <19f34abd0709280511h3f31681bh54c6af287a48c02f@mail.gmail.com>
	 <200709281130.26124.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/28/07, Rob Landley <rob@landley.net> wrote:
> On Friday 28 September 2007 7:11:03 am Vegard Nossum wrote:
> > wrong. We can, however, use KBUILD_MODNAME as a default value for
> > KPRINT_DRIVER, like:
> > static const char *KPRINT_DRIVER = KBUILD_MODNAME;
> > which would pre-process to something like:
> > static const char *KPRINT_DRIVER = "bcm43xx";
>
> Which has been known to result in the string getting written out to the .o
> file even if it's never used, just in case something tries to take its
> address.  This is not the same as a #define.

Logic tells me that an unused static variable should never go into the
.o. If something tries to take its address, it's no longer unused.

> > This value can still be overridden using #define KPRINT_DRIVER "new
> > name".
>
> Not with -D on the command line though.  Your #define would have to come after
> the declaration or else the declaration turns into 'char *"fred" = "george";'
> and you have a syntax error.  Again, not synonymous with a #define...

Yeah, that's exactly what my e-mail was about. The macros
KPRINT_SUBSYSTEM and KPRINT_DRIVER are not defined on the command
line, but in each source file that wants this prefix, after the
variables with the same names have been declared in kprint.h. This is
intentional; they can be overridden with a define, otherwise, they'll
default to static-const string variables.

Vegard
