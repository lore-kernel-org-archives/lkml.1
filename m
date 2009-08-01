Return-Path: <linux-kernel-owner+w=401wt.eu-S1752381AbZHAID1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381AbZHAID1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 04:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbZHAID0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 04:03:26 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3609 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbZHAIDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 04:03:25 -0400
Subject: Re: [PATCH] Moorestown RAR Handler driver, MRST 2.6.31-rc3
From: Joe Perches <joe@perches.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ossama Othman <ossama.othman@intel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20090801073053.GA30389@merkur.ravnborg.org>
References: <1249082419-27718-1-git-send-email-ossama.othman@intel.com>
	 <20090801073053.GA30389@merkur.ravnborg.org>
Content-Type: text/plain
Date: Sat, 01 Aug 2009 01:03:02 -0700
Message-Id: <1249113782.27999.14.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-08-01 at 09:30 +0200, Sam Ravnborg wrote:
> > +#include "memrar_allocator.h"
> > +#include <linux/slab.h>
> > +#include <linux/bug.h>
> 
> <linux/...> comes _before_ you own includes.

The use of pr_fmt might change this guideline.

> > +		WARN(capacity < block_size * 2,
> > +		     "Memory allocator is only large enough to "
> > +		     "hold one block.\n");
> 
> Try to avoid breaking your printable line.
> It is much easier to grep for the line when it is on a single
> line.
> If you violate the 80 chars per line rule do to this then accept
> that grepable lines is better than keeping them 80 or less wide.

Maybe it's better to ignore the indent guideline here as well.
An outdent might be preferable to having the line exceed 80 chars.

Maybe:
		WARN(capacity < block_size * 2,
	"Memory allocator is only large enough to hold one block.\n");
or
		WARN(capacity < block_size * 2, 
"Memory allocator is only large enough to hold one block.\n");

Any format string longer than 80 chars is likely a poor log entry.


