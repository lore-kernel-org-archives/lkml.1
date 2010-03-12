Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586Ab0CLTpX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 14:45:23 -0500
Received: from smtp.nokia.com ([192.100.122.230]:21091 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190Ab0CLTpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 14:45:21 -0500
Date: Fri, 12 Mar 2010 21:45:17 +0200
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: ext Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Nikula Jani.1 (EXT-Nixu/Helsinki)" <ext-jani.1.nikula@nokia.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] err.h: add __must_check to error pointer handlers
Message-ID: <20100312194517.GU5610@pcarmody-desktop>
References: <1268401540-8994-1-git-send-email-ext-jani.1.nikula@nokia.com> <20100312184056.GA4107@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100312184056.GA4107@x200>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 12 Mar 2010 19:45:04.0867 (UTC) FILETIME=[83262B30:01CAC21C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/10 19:40 +0100, ext Alexey Dobriyan wrote:
> On Fri, Mar 12, 2010 at 03:45:40PM +0200, Jani Nikula wrote:
> > Add __must_check to error pointer handlers to have the compiler warn
> > about mistakes like:
> > 
> > 	if (err)
> > 		ERR_PTR(err);
> 
> > -static inline void *ERR_PTR(long error)
> > +static inline void * __must_check ERR_PTR(long error)
> 
> We had bugs like that?

Two popped out immediately. Patches have been sent to appropriate
maintainers. Grepping my inbox:

Mar 12 Nikula Jani [PATCH] enclosure: fix error path - actually return ERR_PTR() on error
Mar 12 Nikula Jani [PATCH] sunrpc: fix error path - actually return ERR_PTR() on error

There's a slim chance that there may be others (grep doesn't find any
more obvious ones), but as allmodconfig seems broken currently, there
may be others which are as yet undiscovered. 

> Pretty much every non-void function should be marked then.

All functions where it makes no sense ignore the return value. You
really wouldn't be doing an ERR_PTR unless you wanted to use the result.

Note that __must_check doesn't actually require 'checking', merely
'using' the return value, which includes just storing it in a variable,
and then later ignoring it.

An alternative static code analysis method could be used to detect such 
things. Coverity Prevent uses a heuristic algorithm to detect missing 
checks of return values using a popularity contest. Most people check 
it - then everyone should probably check it.

Phil
