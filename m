Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952AbYGRPVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbYGRPVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 11:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbYGRPVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 11:21:13 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:35659 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751277AbYGRPVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 11:21:13 -0400
Date: Fri, 18 Jul 2008 11:21:07 -0400
From: Theodore Tso <tytso@mit.edu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: Re: The request_firmware() changes causing problems with make-kpkg
Message-ID: <20080718152107.GA18847@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
	sam@ravnborg.org
References: <20080718115833.GC11221@mit.edu> <1216390475.31897.36.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216390475.31897.36.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 07:14:35AM -0700, David Woodhouse wrote:
> > Given that Ubuntu's firmware loader already tries to find firmware at
> > /lib/firmware/<kpkg> and only if that fails, to load it from
> > /lib/firmware, it seems like the obvious thing to do is to add a
> > quickie CONFIG option which changes the default setting of
> > INSTALL_FW_PATH in the top-level makefile from /lib/firwmare to
> > /lib/firmware/<kver>.
> 
> I assume those are actually the same -- <kpkg> vs. <kver>?

Yes, sorry.  I was typing too fast.

> Hm. The way we normally override such paths is with make variables.
> 
> If you really can't just fix make-kpkg to set INSTALL_FW_PATH when
> installing modules, you could export MAKEFLAGS=INSTALL_FW_PATH=/foo
> before invoking make-kpkg.
> 
> Your logic is that it's easier for you to update your config than to
> override $(INSTALL_FW_PATH) by either method above? 

Well, make-kpkg is a little easier to follow and modify than say, Red
Hat's kernel-building rpm macros (a task which I wouldn't wish on my
worst enemy, having done it once in the RHEL4 era), but that's not
saying much.  But *yes*, much easier to modify my config.  :-)

       	      	  	      	     	       - Ted
