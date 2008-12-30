Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074AbYL3PqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbYL3PqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 10:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbYL3PqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 10:46:04 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:50040 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbYL3PqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 10:46:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LdsEuskR81WbBNYKhu9T+K8HVVJT7ELH8nHBh7hHXcuXZMYxIvd1i6sE/beIUMZD48
         mWZAqKPq9udVdWN9IgOtkYCZcqLNKolJlZHPsX1K9bLTfdR51wguxPHDZQe0hQQ2OUZi
         qc3HA4m3lyf/pe9VuT8T4lHF1KUM2s32YhFwo=
Message-ID: <45a44e480812300745p969f1dfi9ea837b611395a3e@mail.gmail.com>
Date: Tue, 30 Dec 2008 23:45:58 +0800
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [RFC 2.6.27 1/1] gpiolib: add support for batch set of pins
Cc: "Eric Miao" <eric.y.miao@gmail.com>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Eric Miao" <eric.miao@marvell.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Philipp Zabel" <philipp.zabel@gmail.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Ben Gardner" <bgardner@wabtec.com>, "Greg KH" <greg@kroah.com>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
In-Reply-To: <200812291132.14806.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12276535632759-git-send-email-jayakumar.lkml@gmail.com>
	 <45a44e480811301710v78875425p75dedd850728cbec@mail.gmail.com>
	 <45a44e480812270655u10bde0d2mc7f429cf47ed7bc6@mail.gmail.com>
	 <200812291132.14806.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Mon, Dec 29, 2008 at 2:32 PM, David Brownell <david-b@pacbell.net> wrote:
>
>  - passing bitmasks as {unsigned long *bits, int count} tuples
>  - separate calls to:
>     * zero a set of bits (loop: gpio_set_value to 0)
>     * fill a set of bits (loop: gpio_set_value to 1)
>     * copy a set of bits (loop: gpio_set_value to src[i])
>     * read a set of bits (loop: dst[i] = gpio_get_value)
>     * ... maybe more

I had read bitmasks.h as per your recommendation and my thought on
that was: How do I reconcile such a substantial API when the use case
is just setting/getting a bunch of gpio pins?

>
> Any restriction to 32 bit value seems shortsighted.  It would
> make sense to wrap the GPIO bitmask descriptions in a struct,
> letting drivers work with smaller sets -- probably most would
> fit into a single "unsigned long".
>

Hmm. Well. Currently, there's only been 1 bit support and its been
that way for years, hasn't it? It was not shortsighted at that time to
have only 1 bit access. No one raised a need for more. There weren't
any complaints about the 1-bit gpio API until am300epd.c came along.

You had correctly pointed out "I happen not to have come across the
need for such ganged access from Linux" in the start of this thread. I
think that you raised a strong point there. If I understood you
correctly, it implies it is NOT likely that there'll be many users of
this ganged access API.

Which is precisely why I took your suggestion to heart and stuck to
the middle path. For better or worse, we currently have a grand total
of just one use case for this ganged API: am300epd.c which does a
16-bit write. No one has spoken up with another concrete use case. So
I say we stick to the simple 32-bit startpin/mask/length API. Lets see
if people start using it. If more than a few do and issues are raised
with it being limited to "just 32 bits", then we can rearchitecht as
needed. After all, as you requested, it's an optional in-kernel only
API so we're in no danger of shooting ourselves in the foot here.
Further more, we've gone from years of 1-bit access with no complaints
to 32-bit access. A factor of 32 improvement seems a reasonably good
bet for the next few years to me. :-)

If any of my assertions are mistaken, I'll need your help to
understand which specific part of the conversation I've misunderstood.

Thanks,
jaya
