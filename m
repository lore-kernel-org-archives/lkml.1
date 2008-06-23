Return-Path: <linux-kernel-owner+w=401wt.eu-S1756348AbYFWOA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348AbYFWOA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 10:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbYFWOAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 10:00:19 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:38299 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753147AbYFWOAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 10:00:18 -0400
X-Sasl-enc: 50iUIgyacrohsgpXmVA8S0uelGFGdZzpjLQx+uR6R1yN 1214229616
Date: Mon, 23 Jun 2008 11:00:12 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pavel Machek <pavel@suse.cz>
Cc: Kyle Moffett <mrmacman_g4@mac.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, David Chinner <dgc@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, xfs-masters@oss.sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Elias Oltmanns <eo@nebensachen.de>
Subject: Re: freeze vs freezer
Message-ID: <20080623140012.GA11899@khazad-dum.debian.net>
References: <4744FD87.7010301@goop.org> <200711262253.35420.rjw@sisk.pl> <20071127053846.GA28884@srcf.ucam.org> <200711271840.24825.rjw@sisk.pl> <8B00F353-983F-40E7-931B-EA73CCD32F0A@mac.com> <20080623071601.GA1553@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080623071601.GA1553@elf.ucw.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2008, Pavel Machek wrote:
> (replying to *very* old mail).
> 
> >>>> We wait until they can continue.
> >>>
> >>> So if I have a process blocked on an unavilable NFS mount, I can't
> >>> suspend?
> >>
> >> That's correct, you can't.
> >>
> >> [And I know what you're going to say. ;-)]
> >
> > Why exactly does suspend/hibernation depend on "TASK_INTERRUPTIBLE" instead 
> > of a zero preempt_count()?  Really what we should do is just iterate over 
> > all of the actual physical devices and tell each one "Block new IO requests 
> > preemptably, finish pending DMA, put the hardware in low-power mode, and 
> > prepare for suspend/hibernate".  As long as each driver knows how to do 
> > those simple things we can have an entirely consistent kernel image for 
> > both suspend and for hibernation.
> 
> Patch would be welcome, actually. It turns out blocking new
> IO-requests is not completely trivial.

Is this the same thing the per-device IO-queue-freeze patches for HDAPS also
need to do?  If so, you may want to talk to Elias Oltmanns
<eo@nebensachen.de> about it.  Added to CC.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
