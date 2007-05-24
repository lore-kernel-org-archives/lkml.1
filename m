Return-Path: <linux-kernel-owner+w=401wt.eu-S1757099AbXEXW1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099AbXEXW1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753822AbXEXW1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:27:04 -0400
Received: from smtp27.orange.fr ([80.12.242.95]:33443 "EHLO smtp27.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044AbXEXW1B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:27:01 -0400
X-Greylist: delayed 4912 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 May 2007 18:27:01 EDT
X-ME-UUID: 20070524210505570.8B3FF1C0008D@mwinf2723.orange.fr
From: "Yann E. MORIN" <yann.morin.1998@anciens.enib.fr>
Organization: BZH Corp.
To: kbuild-devel@lists.sourceforge.net
Subject: Re: [kbuild-devel] [rfe] easier customization of kconfig for non-Linux projects
Date: Thu, 24 May 2007 23:05:04 +0200
User-Agent: KMail/1.9.5
Cc: Sam Ravnborg <sam@ravnborg.org>, Mike Frysinger <vapier@gentoo.org>,
       Roman Zippel <zippel@linux-m68k.org>, linux-kernel@vger.kernel.org
References: <200705240117.39800.vapier@gentoo.org> <20070524064004.GA28923@uranus.ravnborg.org>
In-Reply-To: <20070524064004.GA28923@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705242305.04930.yann.morin.1998@anciens.enib.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all!

Sorry to jump into the discussion, but...

On Thursday 24 May 2007 08:40, Sam Ravnborg wrote:
> The intent with this is clear but the solution you suggest albeit simple
> does not really match where we could end up with kconfig.
> Recently Roman added support for options in the kconfig language
> and I would assume we could deal with most of this just using options.
> 
> One example could be to support options for the mainmenu entrye like this:
> 
> mainmenu "Busybow config system"
> 	option project="Busybox"
> 	option version="$VERSION"   <= Where '$' signify an environment variable

I would rather suggest a kind of 'namespace' thing. This way, one could use
the kconfig language for a project (eg. buildroot) and include sub-Kconfig
files from other sub-projects (eg. kernel), thus making all configurable
from the same menu.

Something like (syntax proposal):

----8<----
mainmenu "Buildroot config system"
    option prefix=""                <= prefix to config options

config foo                          => foo=y    /   # foo is not set
    blah blah blah...

namespace "Buildroot options"
    option project="Buildroot"
    option version="${VERSION}"     <= To avoid $VERSION_test ambiguity
    option prefix="BR2_"            <= prefix to config options

config bar                          => BR2_bar=y   /   # BR2_bar is not set
    blah blah blah...

endnamespace

namespace "Linux Kernel options"
    option project="Linux"
    option version="..."
    option prefix="CONFIG_"

include "${BR2_KERNEL_DIR}/arch/${BR2_ARCH]/Kconfig"

endnamespace
----8<----

Then with a simple grep -E '^CONFIG_' one can easily extract the kernel
options from the others.

We _may_ need to support nested namespaces also, concatenating the prefixes.

I once tried to do such thing, but I'm lacking good lex/yacc fu, and I
miserably failed... :-(

Comments?

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +0/33 662376056 | Software  Designer | \ / CAMPAIGN     |   ^                |
| --==< °_° >==-- °------------.-------:  X  AGAINST      |  /e\  There is no  |
| http://ymorin.is-a-geek.org/ | (*_*) | / \ HTML MAIL    |  """  conspiracy.  |
°------------------------------°-------°------------------°--------------------°

