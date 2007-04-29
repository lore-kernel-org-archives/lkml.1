Return-Path: <linux-kernel-owner+w=401wt.eu-S1754490AbXD2AiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbXD2AiQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 20:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754494AbXD2AiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 20:38:16 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:47391 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490AbXD2AiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 20:38:15 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4633E8EF.1080604@s5r6.in-berlin.de>
Date: Sun, 29 Apr 2007 02:38:07 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: maturity levels:  a first pass
References: <Pine.LNX.4.64.0704281735470.29040@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0704281735470.29040@localhost.localdomain>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> +	  This feature gives you the ability to de-select entire sets of
> +	  kernel features based on how they've been tagged with the
> +	  "maturity" directive.

Why expose the end-user to implementation details like "been tagged with
the 'maturity' directive"?

...
> +config MATURITY_DEPRECATED
> +	bool "Display DEPRECATED features."
...

Maybe you rather want

	bool "Allow to select DEPRECATED features."

because MATURITY_DEPRECATED=N probably means "Do not allow to select
DEPRECATED features" which implies that deprecated features will be
deselected.  In your wording, MATURITY_DEPRECATED=N would be just "Do
not display DEPRECATED features" which is probably less than what you
want it to be.

That said, I don't know if the approach is going into the right
direction.  For example, the way you are starting it requires updates to
all Kconfig UIs/scripts, to work correctly.  Otherwise, users could
select ACTIVATE_MATURITY but the tags would still be ignored.

Another approach could be to
  - continue to use "config EXPERIMENTAL" and "depends on EXPERIMENTAL"
    and extend it for OBSOLETE, and if you cannot resist, for
    DEPRECATED,
  - extend interactive UIs like xconfig and menuconfig and oldconfig to
    display an EXPERIMENTAL sign alongside the title of an option
    which depends on EXPERIMENTAL,
  - delete occurrences of the string EXPERIMENTAL from titles of options
    and help texts,
  - vice versa for OBSOLETE, and if you cannot resist, for
    DEPRECATED.
This does what you want while it keeps contents separate from
presentation and avoids to extend the Kconfig language.  A simple
Kconfig language without presentational ballast allows for creation of a
multitude of fine-tuned configurator UIs/scripts, which can be extended
by all sorts of features, e.g. better support in dealing with obsolete
configuration options.
-- 
Stefan Richter
-=====-=-=== -=-- ===-=
http://arcgraph.de/sr/
