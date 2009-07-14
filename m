Return-Path: <linux-kernel-owner+w=401wt.eu-S1753426AbZGNNVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbZGNNVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 09:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbZGNNVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 09:21:55 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:49499 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbZGNNVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 09:21:54 -0400
Date: Tue, 14 Jul 2009 14:21:52 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       rpurdie@rpsys.net, lenb@kernel.org, rui.zhang@intel.com,
       corentincj@iksaif.net
Subject: Re: [PATCH 1/3] backlight: Allow drivers to update the core, and
	generate events on changes
Message-ID: <20090714132152.GA22521@srcf.ucam.org>
References: <1247517685-7719-1-git-send-email-mjg@redhat.com> <20090714103006.GA19866@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090714103006.GA19866@khazad-dum.debian.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 07:30:07AM -0300, Henrique de Moraes Holschuh wrote:
> On Mon, 13 Jul 2009, Matthew Garrett wrote:
> > Certain hardware will send us events when the backlight brightness
> > changes. Add a function to update the value in the core, and
> > additionally send a uevent so that userspace can pop up appropriate
> > UI. The uevents are flagged depending on whether the update originated
> > in the kernel or from userspace, making it easier to only display UI
> > at the appropriate time.
> 
> Any reasons to not do it using poll() support (since sysfs has it)?  Or at
> least, do both poll and uevents?

More code? It doesn't really seem necessary.

> Other than that, I like the idea a lot.  thinkpad-acpi will use this event
> support.

Good, that's one of the use-cases I wanted to deal with - but the hotkey 
mask stuff is complicated enough that I hadn't got round to touching 
that yet. The combination of this and the ALSA mixer code should get us 
full notification.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
