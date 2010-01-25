Return-Path: <linux-kernel-owner+w=401wt.eu-S1753998Ab0AYVxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab0AYVxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 16:53:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752748Ab0AYVxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 16:53:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52227 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822Ab0AYVxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 16:53:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] PM / i915: Skip kernel VT switch during suspend/resume if KMS is used
Date: Mon, 25 Jan 2010 22:54:37 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net, Eric Anholt <eric@anholt.net>,
       airlied@linux.ie
References: <201001240055.59479.rjw@sisk.pl> <201001252217.39778.rjw@sisk.pl> <20100125212720.7d3af280@lxorguk.ukuu.org.uk>
In-Reply-To: <20100125212720.7d3af280@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001252254.37635.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 January 2010, Alan Cox wrote:
> > > But in that case we should be able to disable the VT switch disable
> > > path; we just have to check each driver as it's loaded.
> > 
> > OK, what the right sequence of checks would be in that case and where to place
> > them?
> 
> Why are we even driving a vt switch direct from the suspend/resume
> logic ? The problem starts there. If it was being handled off the device
> suspend/resume method then there wouldn't be a mess to start with ?
> 
> Start at the beginning
> 
> - Why do we switch to arbitarily chosen 'last vt'
> - Why isn't vt related suspend/resume handled by the device

Well, that was added long ago as a workaround for some problems people
reported (presumably).  I've never looked at that before, so I can't really
tell why someone did it this particular way.

Obviously I'd like to clean it up, though.

So, what device should handle this in your opinion?

Rafael
