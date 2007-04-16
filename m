Return-Path: <linux-kernel-owner+w=401wt.eu-S1030805AbXDPQAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030805AbXDPQAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 12:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030803AbXDPQAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 12:00:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:37681 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030799AbXDPQAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 12:00:21 -0400
From: Danny Kukawka <dkukawka@suse.de>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] ACPI: more verbose thermal zone shutdown message
Date: Mon, 16 Apr 2007 17:58:45 +0200
User-Agent: KMail/1.9.6
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stefan Seyfried <seife@suse.de>
References: <200704051615.07960.dkukawka@suse.de> <20070415191107.GD10097@ucw.cz>
In-Reply-To: <20070415191107.GD10097@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704161758.45943.dkukawka@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sonntag, 15. April 2007, Pavel Machek wrote:
> Hi!
> 
> > while debug some strange termal shutdowns I wrote this patch to get more 
> > information in /var/log/messages about the reason for the shutdown. I 
> > think this would be useful in general.
> > 
> > Danny
> > 
> > From: Danny Kukawka <dkukawka@suse.de>
> > Subject: ACPI: more verbose thermal zone shutdown message
> > 
> > add more information to acpi thermal zone shutdown message for easier
> > debugging
> > 
> > Signed-off-by: Danny Kukawka <dkukawka@suse.de>
> 
> Yes, please.
[..]
> Why two printks with same info, and why is one of them WARNING and
> second EMERG?

I think this is  what happen and why there are currently two messages:

* if the temperature is really critical you get (now) this:
----------------
kernel: Critical trip point (102 C) reached on Thermalzone [THM]
kernel: Critical temperature reached (150 C on [THM] with trip point set to: 
102 C), shutting down.
----------------

* and if something send a critical temp event to the thermal zone you get:
----------------
kernel: Critical temperature reached (42 C on [THM] with trip point set to: 
102 C), shutting down.
----------------

Maybe we can delete the first one, since you get now also from second 
message the information if the temperature was really critical or if 
there was an other reason for the shutdown, but in the past this was
IMO needed to differ.

Danny
