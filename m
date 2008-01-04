Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646AbYADUyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbYADUyQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 15:54:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbYADUyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 15:54:00 -0500
Received: from smtp-out001.kontent.com ([81.88.40.215]:60846 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbYADUx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 15:53:59 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: nigel@nigel.suspend2.net
Subject: Re: freeze vs freezer
Date: Fri, 4 Jan 2008 21:54:06 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, David Chinner <dgc@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, xfs-masters@oss.sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4744FD87.7010301@goop.org> <200801031215.07145.oliver@neukum.org> <477D5C4F.8050800@nigel.suspend2.net>
In-Reply-To: <477D5C4F.8050800@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801042154.08758.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 3. Januar 2008 23:06:07 schrieb Nigel Cunningham:
> Hi.
> 
> Oliver Neukum wrote:
> > Am Donnerstag, 3. Januar 2008 10:52:53 schrieb Nigel Cunningham:
> >> Hi.
> >>
> >> Oliver Neukum wrote:
> >>> Am Donnerstag 03 Januar 2008 schrieb Nigel Cunningham:
> >>>> On top of this, I made a (too simple at the moment) freeze_filesystems
> >>>> function which iterates through &super_blocks in reverse order, freezing
> >>>> fuse filesystems or ordinary ones. I say 'too simple' because it doesn't
> >>>> currently allow for the possibility of someone mounting (say) ext3 on
> >>>> fuse, but that would just be an extension of what's already done.
> >>> How do you deal with fuse server tasks using other fuse filesystems?
> >> Since they're frozen in reverse order, the dependant one would be frozen
> >> first.
> > 
> > Say I do:
> > 
> > a) mount fuse on /tmp/first
> > b) mount fuse on /tmp/second
> > 
> > Then the server task for (a) does "ls /tmp/second". So it will be frozen,
> > right? How do you then freeze (a)? And keep in mind that the server task
> > may have forked.
> 
> I guess I should first ask, is this a real life problem or a
> hypothetical twisted web? I don't see why you would want to make two
> filesystems interdependent - it sounds like the way to create livelock
> and deadlocks in normal use, before we even begin to think about
> hibernating.

Good questions. I personally don't use fuse, but I do care about power
management. The problem I see is that an unprivileged user could make
that dependency, even inadvertedly.

	Regards
		Oliver

