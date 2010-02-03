Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab0BCOYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 09:24:50 -0500
Received: from gv-out-0910.google.com ([216.239.58.184]:65324 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab0BCOYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 09:24:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=SbvsvD4OBb0UjeYP+UwEtfsxMk1a8FIQt7ps0aZbGEUIjs8NJh71sWK8fuwznset/U
         PVHrLtuUJ2GKzTItitOKG42NJBOPE5nGBharbMrju9pIRPRn1/wp2Qy6RexMQTvBW41F
         Z4gMrVI5/94YHQVkcxMvJlhzdv4T/LLDtDYqs=
Date: Wed, 3 Feb 2010 15:24:43 +0100
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, airlied@linux.ie,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH] PM / i915: Skip kernel VT switch during
 suspend/resume	if KMS is used
Message-ID: <20100203152443.7ce8b340@strolchi>
In-Reply-To: <20100131085419.GI2238@elf.ucw.cz>
References: <201001240055.59479.rjw@sisk.pl>
	<201001252254.37635.rjw@sisk.pl>
	<20100126141726.GA1437@ucw.cz>
	<201001261947.46015.rjw@sisk.pl>
	<20100126145842.GA11295@ucw.cz>
	<20100128000751.099630ed@strolchi>
	<20100131085419.GI2238@elf.ucw.cz>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.19.3; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 Jan 2010 09:54:19 +0100
Pavel Machek <pavel@ucw.cz> wrote:

> On Thu 2010-01-28 00:07:51, Stefan Seyfried wrote:
> > Hi,
> > 
> > On Tue, 26 Jan 2010 15:58:43 +0100 Pavel Machek <pavel@ucw.cz> wrote:
> > > We need vt switch when display is controlled by userland app directly
> > > accessing hw. It may or may not be X (svgalib anyone?,
> > > gtk-on-framebuffer? qtopia?).
> > 
> > anything-on-framebuffer should not be different from plain framebuffer
> > console, or am I missing something?
> 
> It is. At least svgalib accesses hw directly. It probably can run even
> on framebuffer.

If it accesses hw directly, it's not really "anything-on-framebuffer"
anymore, is it? The framebuffer device is there to abstract the
hardware.
 
> Well, for now the "shadow buffer" contains only text, not graphics
> images. So you'd need to enlarge it a lot. Doable but more than one liner.

Yes, noticed this today. I was using bootsplash-patched kernels, which
are obviously different in this aspect, so that shifted my view on
reality ;)
-- 
Stefan Seyfried

"Any ideas, John?"
"Well, surrounding them's out."
