Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858AbYGIWb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbYGIWb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 18:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751801AbYGIWbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 18:31:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48673 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383AbYGIWbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 18:31:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Theodore Tso <tytso@mit.edu>
Subject: Re: request_firmware vs. resume (was Re: [PATCH] bnx2 - use request_firmware())
Date: Thu, 10 Jul 2008 00:33:10 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@suse.cz>, David Miller <davem@davemloft.net>,
       alan@lxorguk.ukuu.org.uk, mchan@broadcom.com, dwmw2@infradead.org,
       bastian@waldi.eu.org, linux-kernel@vger.kernel.org
References: <20080707221950.3dfba435@the-village.bc.nu> <200807092358.32605.rjw@sisk.pl> <20080709222347.GB10976@mit.edu>
In-Reply-To: <20080709222347.GB10976@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807100033.11120.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 10 of July 2008, Theodore Tso wrote:
> On Wed, Jul 09, 2008 at 11:58:31PM +0200, Rafael J. Wysocki wrote:
> > > Translation: so much for saving "non-swappable kernel memory".
> > > Unless, of course we add a pre-suspend hook.  (Which doesn't exist
> > > yet, AFAICT from a quick perusal of Documentation/power/devices.txt.)
> > 
> > No, it doesn't.
> > 
> > You will be able to register a suspend notifier instead, but this requires
> > one fix which is in the works.
> 
> Will a suspend notifier be able to block the suspend until userspace
> gets back to the device driver calling request_firmware()?

I think so.

To be exact, I'm going to put the disabling of usermode helpers after the
invocation of the suspend notifiers and that will wait for all of the already
running helpers to finish.

Thanks,
Rafael
