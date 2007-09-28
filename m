Return-Path: <linux-kernel-owner+w=401wt.eu-S1756375AbXI1Ltx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375AbXI1Ltx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 07:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbXI1Ltq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 07:49:46 -0400
Received: from el-out-1112.google.com ([209.85.162.177]:10020 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbXI1Lto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 07:49:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pGlkQCIlqzwximl67qK/NWPcnXJvt3QGMy0CvfGC2ZimP8IU+34f1h6tiM6wQKVWhPsbVN611/84SjOk7mtsLHF7WtgiVi3rzozVOSUIKq3tAOVV8WaafbjqFAJ04kyLKYDk6h/BoQvjbTjmm5NIE5wnqfWjjhNDlDvNZxpXaak=
Message-ID: <19f34abd0709280449s34042f9cxfeaa7364a3659f0@mail.gmail.com>
Date: Fri, 28 Sep 2007 13:49:43 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Kyle Moffett" <mrmacman_g4@mac.com>
Subject: Re: [RFC] New kernel-message logging API (take 2)
Cc: "Geert Uytterhoeven" <geert@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Michael Holzheu" <holzheu@linux.vnet.ibm.com>,
       "Joe Perches" <joe@perches.com>, "Rob Landley" <rob@landley.net>,
       "Dick Streefland" <dick.streefland@altium.nl>,
       "Jesse Barnes" <jesse.barnes@intel.com>,
       "Arnd Bergmann" <arnd@arndb.de>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Emil Medve" <Emilian.Medve@freescale.com>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>,
       "linux@horizon.com" <linux@horizon.com>
In-Reply-To: <DC4D133C-42B3-4CE3-A7A9-C507AE8A0B92@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0709271418l471cf7b9gf24161190772fac@mail.gmail.com>
	 <Pine.LNX.4.64.0709280922230.32185@anakin>
	 <DC4D133C-42B3-4CE3-A7A9-C507AE8A0B92@mac.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/28/07, Kyle Moffett <mrmacman_g4@mac.com> wrote:
> On Sep 28, 2007, at 03:31:11, Geert Uytterhoeven wrote:
> > Can't you store the loglevel in the kprint_block and check it in
> > all successive kprint_*() macros? If gcc knows it's constant, it
> > can optimize the non-wanted code away. As other fields in struct
> > kprint_block cannot be constant (they store internal state), you
> > have to split it like:
> >
> >     struct kprint_block {
> >           int loglevel;
> >           struct real_kprint_block real;  /* internal state */
> >     }
> >
> > and pass &block.real() instead of &block to all successive internal
> > functions.  I haven't tried this, so let's hope gcc is actually
> > smart enough...
>
> Well actually, I believe you could just do:
>
> struct kprint_block {
>         const int loglevel;
>         [...];
> };
>
> Then cast away the constness to actually set it initially:
> *((int *)&block.loglevel) = LOGLEVEL;

This doesn't seem to work either (i.e. it is not optimized out). I
tried initializing the struct statically too, to no avail. But thanks
for the tip.

Vegard
