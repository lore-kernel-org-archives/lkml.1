Return-Path: <linux-kernel-owner+w=401wt.eu-S1757727AbZB0Oaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727AbZB0Oaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 09:30:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbZB0Oao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 09:30:44 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:38928 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbZB0Oan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 09:30:43 -0500
Date: Fri, 27 Feb 2009 14:29:46 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Arve Hj?nnev?g <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090227142946.GA13650@srcf.ucam.org>
References: <200902192215.18365.rjw@sisk.pl> <200902210057.27781.rjw@sisk.pl> <20090227100941.GE4582@elf.ucw.cz> <200902271522.41915.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902271522.41915.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 27, 2009 at 03:22:39PM +0100, Rafael J. Wysocki wrote:
> On Friday 27 February 2009, Pavel Machek wrote:
> > Wakelocks done right are single atomic_t... and if you set it to 0,
> > you just unblock "sleeper" thread or something. Zero polling and very
> > simple...
> 
> Except that you have to check all of the wakelocks periodically in a loop =>
> polling.  So?

Why do you need to check them? If you're taking this approach you just 
have something like:

suspend_unblock() {
	if (atomc_dec_and_test(&suspend_lock))
		suspend();
}

and then check that the lock count is still 0 after device_suspend(). 
There's no need to poll.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
