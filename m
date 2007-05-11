Return-Path: <linux-kernel-owner+w=401wt.eu-S1760410AbXEKMVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760410AbXEKMVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 08:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756055AbXEKMVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 08:21:10 -0400
Received: from allen.werkleitz.de ([80.190.251.108]:52912 "EHLO
	allen.werkleitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510AbXEKMVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 08:21:08 -0400
Date: Fri, 11 May 2007 14:21:13 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: jimmy bahuleyan <knight.camelot@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Jesper Juhl <jesper.juhl@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Heikki Orsila <shdl@zakalwe.fi>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Satyam Sharma <satyam.sharma@gmail.com>
Message-ID: <20070511122113.GB15972@linuxtv.org>
References: <6143.1178828419@lwn.net> <464382DE.5020206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464382DE.5020206@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 87.162.82.123
Subject: Re: [PATCH] "volatile considered harmful", take 2
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on allen.werkleitz.de)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2007 at 02:08:54AM +0530, jimmy bahuleyan wrote:
> Jonathan Corbet wrote:
> [snip..]
> > +
> > +  - The jiffies variable is special in that it can have a different value
> > +    every time it is referenced, but it can be read without any special
> > +    locking.  So jiffies can be volatile, but the addition of other
> > +    variables of this type is strongly frowned upon.  Jiffies is considered
> > +    to be a "stupid legacy" issue in this regard.
> 
> Why is it that you consider jiffies to be a "stupid legacy"? Isn't it
> natural to have a externally modified variable which is only /read/ to
> be volatile? (or is jiffies supposed to be replaced with something
> smarter/better :)

"stupid legacy" were Linus' words. http://lwn.net/Articles/233482/

How about this:

"The jiffies variable is a special case because there are too
many places in the kernel which would have to be changed and reviewed
if the volatile would be removed from jiffies. However, the
use of volatile qualifier for jiffies is just as wrong as
it is elsewhere. Don't use jiffies as an excuse to use volatile
in your code."


Johannes
