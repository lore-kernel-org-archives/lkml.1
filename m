Return-Path: <linux-kernel-owner+w=401wt.eu-S1758889AbXI1Qao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758889AbXI1Qao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 12:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758560AbXI1Qac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 12:30:32 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:36645
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758368AbXI1Qab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 12:30:31 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: [RFC] New kernel-message logging API (take 2)
Date: Fri, 28 Sep 2007 11:30:25 -0500
User-Agent: KMail/1.9.6
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
References: <19f34abd0709271418l471cf7b9gf24161190772fac@mail.gmail.com> <19f34abd0709280511h3f31681bh54c6af287a48c02f@mail.gmail.com>
In-Reply-To: <19f34abd0709280511h3f31681bh54c6af287a48c02f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709281130.26124.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 September 2007 7:11:03 am Vegard Nossum wrote:
> wrong. We can, however, use KBUILD_MODNAME as a default value for
> KPRINT_DRIVER, like:
> static const char *KPRINT_DRIVER = KBUILD_MODNAME;
> which would pre-process to something like:
> static const char *KPRINT_DRIVER = "bcm43xx";

Which has been known to result in the string getting written out to the .o 
file even if it's never used, just in case something tries to take its 
address.  This is not the same as a #define.

> This value can still be overridden using #define KPRINT_DRIVER "new
> name".

Not with -D on the command line though.  Your #define would have to come after 
the declaration or else the declaration turns into 'char *"fred" = "george";' 
and you have a syntax error.  Again, not synonymous with a #define...

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
