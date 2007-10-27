Return-Path: <linux-kernel-owner+w=401wt.eu-S1754659AbXJ0MTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbXJ0MTj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 08:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbXJ0MTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 08:19:32 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:49884 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259AbXJ0MTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 08:19:31 -0400
Date: Sat, 27 Oct 2007 14:21:07 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Markus Elfring <Markus.Elfring@web.de>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org
Subject: Re: Check handling of kernel build output directory
Message-ID: <20071027122107.GA30805@uranus.ravnborg.org>
References: <fft89p$rko$1@ger.gmane.org> <19f34abd0710261036m65fd0d3bjace68c860a29023b@mail.gmail.com> <fftcal$dim$1@ger.gmane.org> <fftdpt$iqf$1@ger.gmane.org> <Pine.LNX.4.64.0710271332440.30465@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710271332440.30465@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2007 at 01:32:54PM +0200, Jan Engelhardt wrote:
> 
> On Oct 26 2007 21:05, Markus Elfring wrote:
> >>> Aren't you supposed to use O= as described by "make help"?
> >> 
> >> I expect that both ways should work. I find it easier to use the environment variable
> >> "KBUILD_OUTPUT" because the command line parameter does not need to be repeated on each
> >> make invocation.
> >
> >A wording correction:
> >I expect that both ways should work. I find it easier to use the environment variable
> >"KBUILD_OUTPUT" because it does not need to be repeated on each make invocation like it
> >must happen with the command line parameter "O=".
> 
> So why not just...
> 	export O=/foo/bar

When introducing the make O=...
I was a bit anal about where the definition of O came from so you will see
that in the top-level Makefile we check if O= is defined at the commandline:

ifdef O
  ifeq ("$(origin O)", "command line")
    KBUILD_OUTPUT := $(O)
  endif
endif

"O" is just too vague to be picked up from the environment.

	Sam
