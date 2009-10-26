Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489AbZJZBwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbZJZBwb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 21:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754415AbZJZBwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 21:52:30 -0400
Received: from foo.birdnet.se ([213.88.146.6]:52802 "HELO foo.birdnet.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752559AbZJZBwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 21:52:30 -0400
Message-ID: <20091026015230.6438.qmail@stuge.se>
Date: Mon, 26 Oct 2009 02:52:30 +0100
From: Peter Stuge <peter@stuge.se>
To: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
Cc: linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org, mjg@redhat.com,
       eric@anholt.net
Subject: Re: no video output after suspend after "drm/i915: force mode set
	at lid open time"
Mail-Followup-To: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>,
	linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
	mjg@redhat.com, eric@anholt.net
References: <4AE4BBBC.2070809@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE4BBBC.2070809@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Riccardo Magliocchetti wrote:
> i lost video output, screen stays black, after suspend after commit
> c1c7af60892070e4b82ad63bbfb95ae745056de0 "drm/i915: force mode set at lid 
> open time".

I also experience this symptom.

I have an IBM ThinkPad X40, chipset with integrated 855GM graphics.

The last release kernel I used was 2.6.30, with DRI enabled but no fb.
Gentoo xorg-server-1.6.1.092 with xf86-video-intel-2.7.1. All vanilla
kernels. With that kernel I would get the mode back on restore, but
the panel backlight would not come on, so it would be very difficult
to see the screen contents, especially in dim environments.

thinkwiki.org documents this symptom on X40 and many other models.
One suggested workaround is to chvt 1 and save a copy of the VGA
device PCI config space right before echo mem > /sys/power/state,
and write it back and run vbetool post immediately after resume,
followed by chvt 7 (or wherever X is). This workaround functioned
fairly well for me, but not always reliably, and of course it's a
bit of a hack. :)

I am now running drm-intel.git a83a44 from Oct 14 with KMS enabled
and xf86-video-intel 1556c62 from Oct 8, and the workaround
(understandably) does not function anymore. I've tried permutations
with only saving PCI config space and only running vbetool but no go.

(Before this I tried 2.6.31.1 with KMS, but it didn't do Xv.)

(Oh, and Xv performance with a83a44+1556c6 is lower than 2.6.30 nofb,
but that's somewhat secondary. MPlayer performs worse than VLC, but
both are worse than MPlayer with 2.6.30+2.7.1.)

Can I help solve this somehow?


//Peter
