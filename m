Return-Path: <linux-kernel-owner+w=401wt.eu-S1759091AbZE0Sul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759091AbZE0Sul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 14:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760522AbZE0Su2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 14:50:28 -0400
Received: from mail-qy0-f190.google.com ([209.85.221.190]:57133 "EHLO
	mail-qy0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761371AbZE0Su0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 14:50:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YIDVVYOfnCcd21lP0WR9Cq9j/nodBzyZaIwIsJERpHDVTciEIOQ7EBB35xGYgb9Xyo
         av1VOQHSb1s+pozlwoKTFd40fp/GPwL7iY4nTHXSoFFXrD4PvY4aSlt/4faGk+W7hQQQ
         bpvRHT4v4kQZieXPwE/L+FDSOzXwnAN7Lc7OY=
MIME-Version: 1.0
In-Reply-To: <20090527163223.GE1970@sirena.org.uk>
References: <1243408083.13460.14.camel@debian-nb>
	 <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com>
	 <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com>
	 <20090527150527.GK6805@pengutronix.de>
	 <20090527163223.GE1970@sirena.org.uk>
Date: Wed, 27 May 2009 14:50:27 -0400
Message-ID: <9e4733910905271150q1d51538draa8d039c8b147c05@mail.gmail.com>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
From: Jon Smirl <jonsmirl@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>,
       Timur Tabi <timur@freescale.com>, Janboe Ye <yuan-bo.ye@motorola.com>,
       Grant Likely <grant.likely@secretlab.ca>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       rmk@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 12:32 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, May 27, 2009 at 05:05:27PM +0200, Robert Schwebel wrote:

>> oftree could be a great tool if these things would be resolved.
>> Currently they are not, and in result, ARM just works and is easy,
>> whereas on PowerPC systems people often spend more time working on
>> binding stuff than on the actual functionality.
>
> This worries me too, my experiences with OF device tree handling for
> ASoC have been pretty negative - but then audio is one of the worst
> cases for handling within the device tree.

ASoC is where I2C was a year ago. I2C had it's own module loading
conventions. OF assumes the subsystem is going to follow the standard
kernel module loading conventions. I2C has now been fixed to use the
standard conventions and it happily works with OF now.

The fight with ASoC is that two different entities are trying to link
the modules together - ASoC (machine drivers) and the device tree
code. There should only be one system linking everything together.
But you want these ASoC machine drivers on ARM because ARM doesn't
have device trees.

I2C had the same problem. I2C wanted everything loaded form machine
drivers. The machine drivers are now optional. ASoC can be fixed in
the same way.

-- 
Jon Smirl
jonsmirl@gmail.com
