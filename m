Return-Path: <linux-kernel-owner+w=401wt.eu-S1758562AbXI1Nax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562AbXI1Nax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 09:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757468AbXI1NaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 09:30:25 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:8782 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757382AbXI1NaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 09:30:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EGzuX7wx7bdRVwGHT21U9PnqM1JhpJOEzzwyoWtRf1EvRiAdTeHA842I0TOmqNlOdMSu+cr5wrXJx7Y/bv9BVCM/2V85WiM101kbZAVoxKBRE/H8umpj+KFvIhRl+w2NsTDWIpdEkOYZ1LxYMddZObQ5dM8/clIxZsekp4dP7TI=
Message-ID: <653402b90709280630t4168abc4rd114aaa5747adc09@mail.gmail.com>
Date: Fri, 28 Sep 2007 15:30:20 +0200
From: "Miguel Ojeda" <maxextreme@gmail.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: [RFC] New kernel-message logging API (take 2)
Cc: LKML <linux-kernel@vger.kernel.org>, "Kyle Moffett" <mrmacman_g4@mac.com>,
       "Michael Holzheu" <holzheu@linux.vnet.ibm.com>,
       "Joe Perches" <joe@perches.com>, "Rob Landley" <rob@landley.net>,
       "Dick Streefland" <dick.streefland@altium.nl>,
       "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>,
       "Jesse Barnes" <jesse.barnes@intel.com>,
       "Arnd Bergmann" <arnd@arndb.de>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Emil Medve" <Emilian.Medve@freescale.com>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>,
       "linux@horizon.com" <linux@horizon.com>
In-Reply-To: <19f34abd0709280511h3f31681bh54c6af287a48c02f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0709271418l471cf7b9gf24161190772fac@mail.gmail.com>
	 <19f34abd0709280511h3f31681bh54c6af287a48c02f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/28/07, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> On 9/27/07, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> >   * Use SUBSYSTEM and KBUILD_MODNAME
>
> snip.
>
> > 2.1.5. Subsystem/driver tags
> >
> >   Many parts of the kernel already prefix their log messages with a
> > subsystem and/or driver tag to identify the source of a particular
> > message. With the kprint interface, these tags are redundant. Instead,
> > the macros SUBSYSTEM and KBUILD_MODNAME are used and recorded along
> > with each log message. Therefore, each source file should define the
> > macro SUBSYSTEM before any of the kprint functions are used. If this
> > macro is not defined, the recorded subsystem will be an empty string.
> > [6][7]
>
> This changes to KPRINT_SUBSYSTEM and KPRINT_DRIVER. The KPRINT_ prefix
> is to clearly say that this is something related to logging. The

Nice. Although the word "DRIVER" may not represent every module, I
think it is the correct option as I suggested, as the word is
meaningful (speaks by itself) and almost every message in the kernel
is printed out by drivers (whatever the big subsystem they belong to:
drivers/,  fs/, net/ ...).

> reason we can't use KBUILD_MODNAME is that this is defined on the
> command line. The declaration inside the header would thus be horribly
> wrong. We can, however, use KBUILD_MODNAME as a default value for
> KPRINT_DRIVER, like:
> static const char *KPRINT_DRIVER = KBUILD_MODNAME;
> which would pre-process to something like:
> static const char *KPRINT_DRIVER = "bcm43xx";
>
> This value can still be overridden using #define KPRINT_DRIVER "new
> name". In this case, it is possible that the original KPRINT_DRIVER
> symbol can cause an "unused variable"-warning. I guess this is fixable
> with the gcc "unused" variable attribute.

Yep, then, in a year or two, we will be able to delete such attribute.

Will there be a team to change main subsystems/drivers to the new API?

-- 
Miguel Ojeda
http://maxextreme.googlepages.com/index.htm
