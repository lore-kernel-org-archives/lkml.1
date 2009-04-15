Return-Path: <linux-kernel-owner+w=401wt.eu-S1755688AbZDOUBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688AbZDOUBu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 16:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbZDOUBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 16:01:39 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:33732 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbZDOUBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 16:01:38 -0400
Date: Wed, 15 Apr 2009 21:01:25 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Niel Lambrechts <niel.lambrechts@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       yakui_zhao <yakui.zhao@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux.kernel" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: 2.6.30-rc1 (latest git): thinkpad-acpi: cannot control brightness with hotkeys (BISECTED)
Message-ID: <20090415200125.GA31483@srcf.ucam.org>
References: <49E10684.5090101@gmail.com> <20090411150555.8b13ed18.akpm@linux-foundation.org> <20090412161448.GC26502@khazad-dum.debian.net> <49E234ED.5010105@gmail.com> <1239585695.5564.5.camel@localhost.localdomain> <49E3575A.60204@gmail.com> <20090413203450.GC16152@khazad-dum.debian.net> <49E5234E.5070303@gmail.com> <20090415164939.GA27807@srcf.ucam.org> <49E63BCB.9090801@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E63BCB.9090801@gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 09:55:55PM +0200, Niel Lambrechts wrote:

> The behaviour seems slightly different from before your 74a365b3f354
> commit in that /sys/class/backlight remains empty until i915 gets loaded
> for the first time, the contents then persist even if i915 is unloaded.
> Perhaps the directory was populated by a different kernel module, since
> when I did the bisect yesterday the directory would be there on boot
> before I started X or loaded i915.

In the past the directory would be created when the acpi video driver 
was loaded, but probably wouldn't work. Doing it that way is a violation 
of the opregion spec and causes some machines to break in a horrible 
manner, so I'd prefer not to go back to that version...

>  I'm not sure if that matters to any other user-space app. (or if
> ideally one is supposed to be able to control brightness in the console
> without having to load i915), but it's fine for controlling brightness
> in Xorg.

If you use modesetting then you shouldn't need to launch X to get 
working brightness control. The problem with the old-style world is that 
you won't get interrupts until X comes up.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
