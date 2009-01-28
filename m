Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbZA1Wk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbZA1Wk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 17:40:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbZA1Wks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 17:40:48 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:34506 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbZA1Wkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 17:40:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CUnfcDQ+4vZuPkC26ncFD/9xgiE7jwZwGW7ZJ2p2ynWnTKYAJgdO/mKDvh493SrccY
         r7kSL/NM8SqPMcOEAANqT6OBP/rdDTHhjtxPoGzRjTl+laT8DLNjBywN0gBnPQc7OdLg
         bj89SG3k2FwtAYOTL2qgIRR/RAZeoGNzLaRTQ=
Subject: Re: [PATCH] x86: do not expose CONFIG_BSWAP to userspace
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "H. Peter Anvin" <hpa@kernel.org>,
       Arnd Bergmann <arnd@arndb.de>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0901281411490.3123@localhost.localdomain>
References: <20090127222825.GA27097@elte.hu>
	 <alpine.LFD.2.00.0901271441280.3123@localhost.localdomain>
	 <1233106614.3256.6.camel@localhost.localdomain>
	 <200901281337.52294.arnd@arndb.de>  <49809A65.2090501@kernel.org>
	 <1233170532.6717.49.camel@brick>
	 <alpine.LFD.2.00.0901281141510.3123@localhost.localdomain>
	 <1233172994.6717.56.camel@brick>  <4980CD51.70601@zytor.com>
	 <1233179884.6717.59.camel@brick>
	 <alpine.LFD.2.00.0901281411490.3123@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 28 Jan 2009 14:40:44 -0800
Message-Id: <1233182444.6717.68.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-28 at 14:13 -0800, Linus Torvalds wrote:
> 
> On Wed, 28 Jan 2009, Harvey Harrison wrote:
> >
> > Use ifdef __i486__ to ensure the BSWAP instruction is available
> > on 32-bit x86.
> > 
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > ---
> > HPA,
> > 
> > I'm afraid my knowledge of gcc compiler flags for various models is
> > lacking, I used i486 as suggested, just wanted to make sure I understood
> > you corectly.
> 
> I really don't think this works.
> 
> Try this:
> 
> 	cpp -dM -m32 -march=pentium t.c | grep i486
> 
> and see the marked absense of __i486__ anywhere.
> 
> At least CONFIG_X86_BSWAP gives the right behaviour for the kernel.

You're right, it doesn't work.  Perhaps just exporting the bswap version
all the time and i386-only people can worry about patching it out?

Harvey



