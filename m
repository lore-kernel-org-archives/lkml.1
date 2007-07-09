Return-Path: <linux-kernel-owner+w=401wt.eu-S1754977AbXGIJPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbXGIJPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 05:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbXGIJPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 05:15:07 -0400
Received: from gate.crashing.org ([63.228.1.57]:58887 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbXGIJPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 05:15:04 -0400
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
In-Reply-To: <200707090852.03429.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0707081619090.11049-100000@netrider.rowland.org>
	 <1183929708.3388.306.camel@localhost.localdomain>
	 <200707090852.03429.oliver@neukum.org>
Content-Type: text/plain
Date: Mon, 09 Jul 2007 19:14:09 +1000
Message-Id: <1183972449.5961.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-09 at 08:52 +0200, Oliver Neukum wrote:
> Am Sonntag, 8. Juli 2007 schrieb Benjamin Herrenschmidt:
> > Another issue that's been a problem forever with suspend is the
> > synchronous request_firmware interface. Lots of drivers do that in
> > resume() which will generally not work.
> 
> Unfortunately yes they do. We now have the notifier chains, which
> can be used. Firmware, especially if it is large, must be requested
> while the system is still fully functional and paging will work.
> 
> Asynchronocity will not help much because the devices must work
> after resumingand delaying that will not help with respect to needing
> devices to get at the firmware.

True, pre-loading is the best approach.

Ben.


