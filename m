Return-Path: <linux-kernel-owner+w=401wt.eu-S1753340Ab0AIAvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab0AIAvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 19:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119Ab0AIAvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 19:51:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751630Ab0AIAvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 19:51:22 -0500
Date: Fri, 8 Jan 2010 16:50:57 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       Zhenyu Wang <zhenyuw@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net
Subject: Re: [PATCH] DRM / i915: Fix resume regression on MSI Wind U100 w/o
 KMS
In-Reply-To: <201001090146.17793.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.1001081648490.7821@localhost.localdomain>
References: <201001090045.33784.rjw@sisk.pl> <alpine.LFD.2.00.1001081548320.7821@localhost.localdomain> <20100108163217.341da699@jbarnes-piketon> <201001090146.17793.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 9 Jan 2010, Rafael J. Wysocki wrote:
> 
> Which is functionally equivalent to my patch, because i915_suspend/resume()
> won't be called by drm_class_suspend/resume() in the KMS case anyway.

Ahh, right you are - that class suspend function does a check for 
DRIVER_MODESET, and only does the suspend/resume if it's not a MODESET 
driver.

Ok, so I withdraw my objections to your original patch - it's confusing, 
but that's just because DRM is such a horrible mess with subtle things.

			Linus
