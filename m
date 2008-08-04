Return-Path: <linux-kernel-owner+w=401wt.eu-S1751608AbYHDVz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608AbYHDVz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759207AbYHDVsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:48:45 -0400
Received: from smtprelay04.ispgateway.de ([80.67.18.16]:56529 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758876AbYHDVsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:48:43 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Keith Packard <keithp@keithp.com>
Subject: Re: files/process scaling problem? (was: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM)
Date: Mon, 4 Aug 2008 23:46:50 +0200
User-Agent: KMail/1.9.9
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>, John Stoffel <john@stoffel.org>,
       Christoph Hellwig <hch@infradead.org>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org
References: <1217573919-7496-1-git-send-email-eric@anholt.net> <20080804151146.71d9fcce@lxorguk.ukuu.org.uk> <1217869134.24714.70.camel@koto.keithp.com>
In-Reply-To: <1217869134.24714.70.camel@koto.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808042346.51391.ioe-lkml@rameria.de>
X-Df-Sender: 849595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 August 2008, Keith Packard wrote:
> On Mon, 2008-08-04 at 15:11 +0100, Alan Cox wrote:
> 
> > X libraries provide the event loop so that isn't really as complex as it
> > seems.
> 
> Uh, no, X doesn't. Gtk+ and Qt provide event loops that applications may
> use, but still many choose to roll their own.

Ok, how many need support for GEM? How many of them would change their
event loop, if they can get better performance?

Maybe have a slow path for legacy behavior?

Really, the sleeping part of of event loops is usually hidden 
in some libraries and the applications have a big switch statement 
somewhere to dispatch the reasons for wakeup.

> >  Shuffling the handles around for the benefit of the odd legacy app
> > isn't something I'd disagree with but DRI and X in the general case can
> > determine the event loop system used by the application.
> 
> Yeah, it would be nice if we could just fix all of the existing
> applications. 

That is never required as long as only performance suffers, 
not functionality.

And the applications doing every syscall themselves are used to the pain :-)


Best Regards

Ingo Oeser
