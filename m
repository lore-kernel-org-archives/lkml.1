Return-Path: <linux-kernel-owner+w=401wt.eu-S932112AbXBWV6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbXBWV6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 16:58:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933224AbXBWV6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 16:58:33 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:26832 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112AbXBWV6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 16:58:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=a4J5doq+GhFbhqfxQ0wBqcGIS24IDjpYsJNtP7uthBmvC6zBsBpLK3S/KaLlTwIwtV4iu6xzzA4f0HDojo2B5wrDmHONvnSjmcSbEWcn3ATHSywQ54dHmVAYA1fhSnYayuxjQqrRiUzTeb7JSK5TQuAK7oy5QucYsZxr0XsCiYQ=
Message-ID: <d120d5000702231358j55cd6665x2add335ceb904c22@mail.gmail.com>
Date: Fri, 23 Feb 2007 16:58:26 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Richard Knutsson" <ricknu-0@student.ltu.se>
Subject: Re: [KJ][RFC][PATCH] BIT macro cleanup
Cc: "Milind Choudhary" <milindchoudhary@gmail.com>,
       kernel-janitors@lists.osdl.org, linux-kernel@vger.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz
In-Reply-To: <45DF3C53.4030100@student.ltu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3b44d3fb0702222056k1d2a9b57q69a3555a09a9058e@mail.gmail.com>
	 <45DEAC45.7090105@student.ltu.se>
	 <3b44d3fb0702230215o2fbd5a3y25729e481a447149@mail.gmail.com>
	 <45DEF5EE.4030002@student.ltu.se>
	 <d120d5000702230657s1860efb3o6986277901f13d03@mail.gmail.com>
	 <45DF1165.2080003@student.ltu.se>
	 <d120d5000702230905r6b50a1bbm3b71551f855cdf01@mail.gmail.com>
	 <45DF2F57.2080309@student.ltu.se>
	 <d120d5000702231037q511f8073n47beed320f097458@mail.gmail.com>
	 <45DF3C53.4030100@student.ltu.se>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/23/07, Richard Knutsson <ricknu-0@student.ltu.se> wrote:
> Dmitry Torokhov wrote:
> >
> > Hm, I thought as was clear, but apparently I messed up explaining my
> > position:
> >
> > 1. I don't like BITWRAP name at all and I don't want anything like
> > that near input code. I think BIT is just fine.
> Oh, I think I understand now. So the (in input.h):
> #undef BIT
> #define BIT(...
> business is what you want to do? Well, that I will not object to.

No, #undefs may be barely tolerable in .c files but they are not
acceptable in core subsystem interfaces. If you do that you will never
know what version of BIT patricular module is using.

>  Your
> patch with:
> +#define BIT(nr)        (1UL << (nr))
> +#define LLBIT(nr) (1ULL << (nr))
> +#define BITWRAP(nr)    (1UL << ((nr) % BITS_PER_LONG))
> in bitops.h made me believe the #undef in input.h was just a temporarily
> thing.

No. There is no "my patch". You are confusing me with Milind
Choudhary. I am saying that IMO input's BIT definition should be
adequate for 99% of potential users and that I would be OK with moving
said BIT definition from input.h to bitops.h and maybe supplementing
it with LLBIT. I am also saying that I do not want BITWRAP, BITSWAP
(what swap btw?) nor BIT(x % BITS_PER_LONG) in input drivers.

-- 
Dmitry
