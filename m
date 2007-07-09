Return-Path: <linux-kernel-owner+w=401wt.eu-S1756022AbXGIGwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbXGIGwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 02:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbXGIGwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 02:52:12 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:41870 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbXGIGwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 02:52:11 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Mon, 9 Jul 2007 08:52:02 +0200
User-Agent: KMail/1.9.7
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <Pine.LNX.4.44L0.0707081619090.11049-100000@netrider.rowland.org> <1183929708.3388.306.camel@localhost.localdomain>
In-Reply-To: <1183929708.3388.306.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707090852.03429.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 8. Juli 2007 schrieb Benjamin Herrenschmidt:
> Another issue that's been a problem forever with suspend is the
> synchronous request_firmware interface. Lots of drivers do that in
> resume() which will generally not work.

Unfortunately yes they do. We now have the notifier chains, which
can be used. Firmware, especially if it is large, must be requested
while the system is still fully functional and paging will work.

Asynchronocity will not help much because the devices must work
after resumingand delaying that will not help with respect to needing
devices to get at the firmware.

	Regards
		Oliver

