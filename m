Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbZBOXLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbZBOXLh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 18:11:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbZBOXLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 18:11:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48502 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754106AbZBOXLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 18:11:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFD] Automatic suspend
Date: Mon, 16 Feb 2009 00:10:15 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902160010.16955.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The recent descussion about the Android PM patches sent by Arve shows that
there is a need to introduce a mechanism allowing us to:
(1) automatically put the system as a whole into a sleep state (eg. suspend to
    RAM) when it is found to be "idle", where the meaning of "idle" has to be
    defined too,
(2) put given subset of devices into low power states whenever they are not
    used, without putting the entire system into a sleep state.
To allow these two things to happen, the Andriod patches introduced the
wakelocks with the associated infrastructure and the "early suspend" mechanism.
However, quite a number of reviewers did not like these patches, for various
reasons, so they cannot be regarded as generally acceptable.  For this reason,
I think, we should discuss the problem in detail from the beginning and try to
find a solution that everyone interested will be comfortable with.

For this purpose, IMO, we should at least reach an agreement on what the
kernel's and the userland's roles in (1) and (2) are going to be.  There also
are quite a few questions that need to be answered.  For instance, what
conditions are going to be used to decide whether or not the system is idle
enough so that we can put it into a sleep state?  How are we going to check
these conditions?  What is going to happen if one (or more) of them changes
while a system-wide power transition (eg. suspend) is in progress?  Are we
going to allow the user space to take part in this and if so, to what extent?
What mechanisms are going be used to put devices into low power states at run
time (ie. before starting any system-wide power transition) and how are they
going to be related to the suspend-resume infrastructure used during
system-wide power transitions?  The answers to these (and other related)
questions will likely affect all of the future Linux PM developlent, so IMO
this is a very important matter.

Opinions and comments welcome.

Thanks,
Rafael
