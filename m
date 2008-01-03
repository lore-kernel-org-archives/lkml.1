Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbYACLPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbYACLPH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 06:15:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbYACLO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 06:14:57 -0500
Received: from smtp-out001.kontent.com ([81.88.40.215]:54181 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbYACLO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 06:14:56 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: nigel@nigel.suspend2.net
Subject: Re: freeze vs freezer
Date: Thu, 3 Jan 2008 12:15:05 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, David Chinner <dgc@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, xfs-masters@oss.sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4744FD87.7010301@goop.org> <200801031047.58559.oliver@neukum.org> <477CB075.5080507@nigel.suspend2.net>
In-Reply-To: <477CB075.5080507@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801031215.07145.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 3. Januar 2008 10:52:53 schrieb Nigel Cunningham:
> Hi.
> 
> Oliver Neukum wrote:
> > Am Donnerstag 03 Januar 2008 schrieb Nigel Cunningham:
> >> On top of this, I made a (too simple at the moment) freeze_filesystems
> >> function which iterates through &super_blocks in reverse order, freezing
> >> fuse filesystems or ordinary ones. I say 'too simple' because it doesn't
> >> currently allow for the possibility of someone mounting (say) ext3 on
> >> fuse, but that would just be an extension of what's already done.
> > 
> > How do you deal with fuse server tasks using other fuse filesystems?
> 
> Since they're frozen in reverse order, the dependant one would be frozen
> first.

Say I do:

a) mount fuse on /tmp/first
b) mount fuse on /tmp/second

Then the server task for (a) does "ls /tmp/second". So it will be frozen,
right? How do you then freeze (a)? And keep in mind that the server task
may have forked.

	Regards
		Oliver
