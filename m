Return-Path: <linux-kernel-owner+w=401wt.eu-S1765134AbXJPAcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765134AbXJPAcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 20:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756219AbXJPAcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 20:32:00 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:33343
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238AbXJPAb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 20:31:59 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] Make m68k cross compile like every other architecture.
Date: Mon, 15 Oct 2007 19:31:54 -0500
User-Agent: KMail/1.9.6
Cc: Sam Ravnborg <sam@ravnborg.org>, Finn Thain <fthain@telegraphics.com.au>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
References: <200710101722.21126.rob@landley.net> <20071012102124.GA18959@uranus.ravnborg.org> <Pine.LNX.4.64.0710152217150.16889@anakin>
In-Reply-To: <Pine.LNX.4.64.0710152217150.16889@anakin>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710151931.54289.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 October 2007 3:25:35 pm Geert Uytterhoeven wrote:
> 64-bit parisc tests if /usr/bin/hppa64-linux-gnu- exists.
> If yes, it sets CROSS_COMPILE to hppa64-linux-gnu-.
> If no, it sets CROSS_COMPILE to hppa64-linux-
>
> 32-bit parisc unconditionally sets CROSS_COMPILE to hppa-linux-.
>
> This still breaks Rob's setup if his compiler is called differently.

Another thing to take into account is that kconfig was recently changed to 
save ARCH and CROSS_COMPILE in the .config file:

http://lwn.net/Articles/253889/

Presumably that means you'd only have to specify your arch and cross compiler 
during config, and then if you re-used that config it would re-use those 
settings.  But the existing makefile discards anything that isn't explicitly 
overridden on the make command line at each stage of the build.

It seems to me any fix should only reset CROSS_COMPILE if there isn't already 
a value for it.  (Otherwise there's a potentially subtle bug where a year 
from now you might have "m68k-linux-gnu-gcc" and "m68k-linux-gnu-pcc" and 
want to compare the results of building with the different compilers.)

I still lean towards considering any attempt to cross compile without setting 
CROSS_COMPILE an error, and not guessing at what the user meant.  But perhaps 
that's just personal preference...

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
