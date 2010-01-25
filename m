Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085Ab0AYWW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab0AYWW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 17:22:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576Ab0AYWW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 17:22:26 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38738 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752503Ab0AYWWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 17:22:25 -0500
Date: Mon, 25 Jan 2010 22:23:00 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net, Eric Anholt <eric@anholt.net>,
       airlied@linux.ie
Subject: Re: [PATCH] PM / i915: Skip kernel VT switch during suspend/resume
 if KMS is used
Message-ID: <20100125222300.62ddc4d2@lxorguk.ukuu.org.uk>
In-Reply-To: <201001252254.37635.rjw@sisk.pl>
References: <201001240055.59479.rjw@sisk.pl>
	<201001252217.39778.rjw@sisk.pl>
	<20100125212720.7d3af280@lxorguk.ukuu.org.uk>
	<201001252254.37635.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Obviously I'd like to clean it up, though.
> 
> So, what device should handle this in your opinion?

My guess would be the relevant device driver for the hardware layer

So fbcon would probably not switch because it can put video modes back,
KMS obvious likewise. The text console might do something as part of its
suspend/resume path IFF the vt in question is in graphics mode.

Alan
