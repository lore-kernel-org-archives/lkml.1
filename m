Return-Path: <linux-kernel-owner+w=401wt.eu-S1755057AbZBPX0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbZBPX0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 18:26:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbZBPX0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 18:26:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58054 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbZBPX0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 18:26:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: [RFD] Automatic suspend
Date: Tue, 17 Feb 2009 00:26:05 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Arve Hj?nnev?g" <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
References: <200902160010.16955.rjw@sisk.pl> <20090216225831.GH1370@ucw.cz>
In-Reply-To: <20090216225831.GH1370@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902170026.06966.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 February 2009, Pavel Machek wrote:
> Hi!
> 
> > The recent descussion about the Android PM patches sent by Arve shows that
> > there is a need to introduce a mechanism allowing us to:
> > (1) automatically put the system as a whole into a sleep state (eg. suspend to
> >     RAM) when it is found to be "idle", where the meaning of "idle" has to be
> >     defined too,
> 
> Well; I'd prefer to keep the interface very minimal.
> 
> If no devices are being used,

We'll need some kind of infrastructure to detect such situations.

> and next wakeup is far enough in the future,

What exactly do you mean by "next wakeup"?

> just put system to sleep.  Long enough == so far away that suspend/wakeup
> is short compared to that... like 20 seconds on PC.

Well 10s will be fine on the majority of my test boxes, but that's a detail.

> Ok, it probably needs to be opt-in: echo auto-mem > /sys/power/state
> should do the trick.

Agreed.

> This will need either fixing all the applications not to poll, or
> maybe someone SIGSTOP-ing apps that are in background and poll too
> often.

Polling in general is not PM-friendly, so we'll need to deal with it somehow
at one point anyway.

Thanks,
Rafael
