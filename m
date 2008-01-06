Return-Path: <linux-kernel-owner+w=401wt.eu-S1758671AbYAFX5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbYAFX5S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 18:57:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbYAFX5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 18:57:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34093 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754773AbYAFX5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 18:57:07 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [linux-pm] Re: [PATCH] PM: Acquire device locks on suspend
Date: Mon, 7 Jan 2008 00:59:15 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Alan Stern" <stern@rowland.harvard.edu>, "Greg KH" <gregkh@suse.de>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "ACPI Devel Maling List" <linux-acpi@vger.kernel.org>,
       "pm list" <linux-pm@lists.linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>
References: <Pine.LNX.4.44L0.0801061734150.20032-100000@netrider.rowland.org> <200801062347.49935.rjw@sisk.pl> <49505.::ffff:91.5.86.36.1199663162.squirrel@secure.sipsolutions.net>
In-Reply-To: <49505.::ffff:91.5.86.36.1199663162.squirrel@secure.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801070059.16741.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 7 of January 2008, Johannes Berg wrote:
> Rafael J. Wysocki wrote:
> 
> >> I don't see anything wrong with it.  All that will happen is that the
> >> removal will start before the suspend and finish after the resume.
> >
> > In that case, we'll attempt to call the device's .suspend() and .resume()
> > routines, but we shouldn't do that, IMHO.
> 
> I don't see anything wrong with that since the driver must be prepared to
> handle that even in the regular case, it's the only thing you can
> guarantee: no more method calls after removal finishes. Am I totally
> misunderstanding things?

Well, we are towards the end of device removal at this point, having called
bus_remove_device(dev) for example, but still we've got it on dpm_active ...

This may not be technically wrong (ie. we should be able to recover from
that), but it seems conceptually wrong and with pm_sleep_rwsem in place it
can be avoided.

Rafael
