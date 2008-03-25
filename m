Return-Path: <linux-kernel-owner+w=401wt.eu-S1758276AbYCYUtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276AbYCYUtq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 16:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbYCYUtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 16:49:39 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:54681 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbYCYUti convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 16:49:38 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [linux-pm] [RFC][PATCH] PM: Introduce new top level =?iso-8859-1?q?suspend=09and_hibernation_callbacks?= (rev. 2)
Date: Tue, 25 Mar 2008 21:49:36 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alan Stern <stern@rowland.harvard.edu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0803251030220.4838-100000@iolanthe.rowland.org> <200803252048.43792.oliver@neukum.org> <200803252141.49049.rjw@sisk.pl>
In-Reply-To: <200803252141.49049.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803252149.37552.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 25. März 2008 21:41:48 schrieb Rafael J. Wysocki:
> On Tuesday, 25 of March 2008, Oliver Neukum wrote:
> > Am Dienstag, 25. März 2008 15:33:22 schrieb Alan Stern:
> > > > so I'd say a
> > > > failure to resume is just a limited subcase of a device vanishing during
> > > > sleep.
> > > 
> > > I'll go along with that.  If a device vanishes during sleep, the PM 
> > > core isn't responsible for unregistering it -- the device's subsystem 
> > > is.
> > 
> > Yes, that makes sense. You are right.
> 
> Still, if ->resume() returns an error, does it make sense, from the PM core's
> point of view, to execute ->complete() for that device, for example?

IMO you must always keep the ordering invariant. If a parent returns an error
the PM core must not wake its children.

	Regards
		Oliver

