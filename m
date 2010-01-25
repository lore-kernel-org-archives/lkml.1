Return-Path: <linux-kernel-owner+w=401wt.eu-S1753214Ab0AYV1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab0AYV1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 16:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166Ab0AYV1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 16:27:21 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57639 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750758Ab0AYV1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 16:27:21 -0500
Date: Mon, 25 Jan 2010 21:27:20 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net, Eric Anholt <eric@anholt.net>,
       airlied@linux.ie
Subject: Re: [PATCH] PM / i915: Skip kernel VT switch during suspend/resume
 if KMS is used
Message-ID: <20100125212720.7d3af280@lxorguk.ukuu.org.uk>
In-Reply-To: <201001252217.39778.rjw@sisk.pl>
References: <201001240055.59479.rjw@sisk.pl>
	<20100125184350.0fbad233@lxorguk.ukuu.org.uk>
	<20100125104938.6b34d61c@jbarnes-piketon>
	<201001252217.39778.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > But in that case we should be able to disable the VT switch disable
> > path; we just have to check each driver as it's loaded.
> 
> OK, what the right sequence of checks would be in that case and where to place
> them?

Why are we even driving a vt switch direct from the suspend/resume
logic ? The problem starts there. If it was being handled off the device
suspend/resume method then there wouldn't be a mess to start with ?

Start at the beginning

- Why do we switch to arbitarily chosen 'last vt'
- Why isn't vt related suspend/resume handled by the device

Alan
