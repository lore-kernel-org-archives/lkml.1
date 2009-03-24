Return-Path: <linux-kernel-owner+w=401wt.eu-S1753542AbZCXWBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbZCXWBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 18:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbZCXWA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 18:00:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39494 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbZCXWA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 18:00:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC][PATCH 0/2] Export platform_pci_set_power_state() and make radeonfb use it
Date: Tue, 24 Mar 2009 23:00:46 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-tst; KDE/4.2.1; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alex Deucher <alexdeucher@gmail.com>
References: <200903210003.55161.rjw@sisk.pl> <200903241200.37982.rjw@sisk.pl> <1237929175.25062.727.camel@pasglop>
In-Reply-To: <1237929175.25062.727.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903242300.47417.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 March 2009, Benjamin Herrenschmidt wrote:
> On Tue, 2009-03-24 at 12:00 +0100, Rafael J. Wysocki wrote:
> 
> > In fact I have yet another idea.  If we use the "retransmission with exponential
> > backoff" algorithm in pci_raw_set_power_state(), we won't have to add any
> > extra parameters to pci_set_power_state() and the radeon case will be covered
> > automatically.  That should also cover any other devices having similar
> > problems IMO.
> > 
> > A patch to implement that is appended, please tell me what you think.
> 
> This is crazy....
> 
> Most devices don't need that and those who are a bit "touchy" may well
> puke on being written to too fast while they are in the middle of
> the transition.
> 
> Let's wait to see if Alex from ATI has an answer here, and if not, I
> would suggest keeping the dirt inside radeonfb.

OK, so what would you like to do exactly?

The only thing I see is not to set current_state to PCI_D2 before calling the
final pci_set_power_state().

Rafael
