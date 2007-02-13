Return-Path: <linux-kernel-owner+w=401wt.eu-S1751067AbXBMVA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751067AbXBMVA5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 16:00:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbXBMVA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 16:00:57 -0500
Received: from neon.samage.net ([83.149.67.130]:39202 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbXBMVA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 16:00:57 -0500
X-Greylist: delayed 2567 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Feb 2007 16:00:56 EST
Message-ID: <4390.81.207.0.53.1171397879.squirrel@secure.samage.net>
In-Reply-To: <20070213142024.GC638@elte.hu>
References: <20070213142024.GC638@elte.hu>
Date: Tue, 13 Feb 2007 21:17:59 +0100 (CET)
Subject: Re: [patch 02/11] syslets: add syslet.h include file,
      user API/ABI definitions
From: "Indan Zupancic" <indan@nul.nu>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@zip.com.au>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Ulrich Drepper" <drepper@redhat.com>
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.7
X-Scan-Signature: ba572e8a3bde05b4b19613c12a9e49fc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, February 13, 2007 15:20, Ingo Molnar wrote:
> +/*
> + * Execution control: conditions upon the return code
> + * of the previous syslet atom. 'Stop' means syslet
> + * execution is stopped and the atom is put into the
> + * completion ring:
> + */
> +#define SYSLET_STOP_ON_NONZERO			0x00000008
> +#define SYSLET_STOP_ON_ZERO			0x00000010
> +#define SYSLET_STOP_ON_NEGATIVE			0x00000020
> +#define SYSLET_STOP_ON_NON_POSITIVE		0x00000040

This is confusing. Why the return code of the previous syslet atom?
Wouldn't it be more clear if the flag was for the current tasklet?
Worse, what is the previous atom? Imagine some case with a loop:

  A
  |
  B<--.
  |   |
  C---'

What will be the previous atom of B here? It can be either A or C,
but their return values can be different and incompatible, so what
flag should B set?

> +/*
> + * Special modifier to 'stop' handling: instead of stopping the
> + * execution of the syslet, the linearly next syslet is executed.
> + * (Normal execution flows along atom->next, and execution stops
> + *  if atom->next is NULL or a stop condition becomes true.)
> + *
> + * This is what allows true branches of execution within syslets.
> + */
> +#define SYSLET_SKIP_TO_NEXT_ON_STOP		0x00000080
> +

Might rename this to SYSLET_SKIP_NEXT_ON_STOP too then.

Greetings,

Indan



