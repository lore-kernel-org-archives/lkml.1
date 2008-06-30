Return-Path: <linux-kernel-owner+w=401wt.eu-S1764286AbYF3UNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764286AbYF3UNN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 16:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbYF3UM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 16:12:57 -0400
Received: from smtp1.riverbed.com ([206.169.144.12]:64285 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbYF3UM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 16:12:56 -0400
Date: Mon, 30 Jun 2008 13:13:40 -0700
From: Arthur Jones <ajones@riverbed.com>
To: Doug Thompson <norsk5@yahoo.com>
CC: Andi Kleen <andi@firstfloor.org>,
       "dougthompson@xmission.com" <dougthompson@xmission.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/13] EDAC i5100 new intel chipset driver
Message-ID: <20080630201340.GI10571@ajones-laptop.nbttech.com>
References: <20080630150346.GF10571@ajones-laptop.nbttech.com> <262167.11235.qm@web50105.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <262167.11235.qm@web50105.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,  ...

On Mon, Jun 30, 2008 at 12:58:59PM -0700, Doug Thompson wrote:
> 
> --- Arthur Jones <ajones@riverbed.com> wrote:
> 
> > > Arthur, could you add some more text to the driver's output, before the call to the
> > > core's output function, doing exactly that? Explaining just what you DO know, and what you
> > don't
> > > know?
> >
> > Everything should be good except the DIMM label.  There
> > are all kinds of ways this could be wrong (mainboard labelling,
> > mainboard routing, ...).  I think it might be better just
> > to leave this blank.
> >
> > Are there any EDAC drivers that properly report the DIMM label?
> 
> The drivers don't print the information just because of these issues. The labeling action is left
> to user space via edac-utils.  The label attributes in sysfs are initialized via a bootup daemon.
> Thereby EDAC (and the driver) provides a mechanism of storing the DIMM Label. (The driver is free
> to populate label if it so chooses, but that too could be overridden by userspace).
> 
> One driver I did for the Sicortex MIPS cluster only had TWO DIMMS, "East" and "West" on a 6 core
> processor card. The driver labeled those inside itself.
> 
> >
> > How do they get around these issues?
> 
> Late binding. Allow the setting of the label by userspace. edac-utils utilizes a file database of
> motherboards, which must be maintained yes, but it is flexible. An additional userspace program
> could source the labels via another mechanism.
> 
> Lawrence Livermore National Labs has tens of thousands of nodes, with 2, 4 or 8 CPUs per node, and
> they are the ones who developed the edac-utils userspace daemon and scripts.
> 
> http://sourceforge.net/projects/edac-utils/
> 
> The model for EDAC modules IS to leave the DIMM label blank for late binding of that information.

Thanks, I didn't know about edac-utils, that sounds much better
than what I was proposing.  I'll go have a look...

Given this, I think it would be best to pull out the labels from
the driver.  I'll see if I can put together a patch for that today
or tomorrow...

Arthur
