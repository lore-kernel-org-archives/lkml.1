Return-Path: <linux-kernel-owner+w=401wt.eu-S1755039AbYCZOYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039AbYCZOYb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 10:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752358AbYCZOYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 10:24:20 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:43963 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbYCZOYT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 10:24:19 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [RFC][PATCH] PM: Introduce new top level =?iso-8859-1?q?suspend=09and_hibernation_callbacks?= (rev. 2)
Date: Wed, 26 Mar 2008 15:24:17 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0803261003540.4755-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0803261003540.4755-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803261524.18300.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 26. März 2008 15:10:01 schrieb Alan Stern:
> > > IMO you must always keep the ordering invariant. If a parent returns an error
> > > the PM core must not wake its children.
> 
> Don't think of it that way.  The PM core doesn't wake anything.  It
> merely notifies drivers that the system sleep is ending, so that the
> drivers can wake their devices.  It's up to the driver to detect
> whether the parent failed to resume, in which case the driver should
> take appropriate action.

How do you propose that every driver should check the power state
of its parent? Without locking the parent?

> The situation is no different from what happens when the user tries to 
> access a mounted USB disk drive after the USB cable has been unplugged.  
> The drivers take care of everything.

That completely throws away the reason to have a PM core. We've made
a guarantee to drivers that they wil not be woken unless their parents are
awake. In fact the semantics of the callbacks are defined in a way that
adding devices to a parent can be enabled. You cannot add children to a
dead parent. It's the very reason for this rewrite.

	Regards
		Oliver
