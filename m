Return-Path: <linux-kernel-owner+w=401wt.eu-S1752085AbZBQCoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbZBQCoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 21:44:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbZBQCn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 21:43:56 -0500
Received: from netrider.rowland.org ([192.131.102.5]:1853 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752081AbZBQCnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 21:43:55 -0500
Date: Mon, 16 Feb 2009 21:43:52 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Arjan van de Ven <arjan@infradead.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
In-Reply-To: <20090216145655.727cd39c@infradead.org>
Message-ID: <Pine.LNX.4.44L0.0902162141190.24097-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Feb 2009, Arjan van de Ven wrote:

> > Set the automatic PM parameters (idle timeout, state to go to,
> > etc.). And disabling automatic PM altogether (effectively the same as
> > setting the idle timeout to infinity).
> > 
> 
> shouldn't idle timeout etc be internal to the driver?
> Yes policy preferences / constraints makes sense to communicate,
> actual settings do not. For one they keep changing fast all the time
> anyway.

Sorry, I don't agree.  A single driver may control many different kinds
of device -- it may not even be aware of the distinction!  Consider the
SCSI disk driver: It has to handle both traditional rotating media and
solid-state disks.  Clearly they should have different runtime PM
parameters.  But the driver isn't in a good position to know what those
parameters should be.

Alan Stern

