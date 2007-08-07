Return-Path: <linux-kernel-owner+w=401wt.eu-S934534AbXHGN7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934534AbXHGN7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 09:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763013AbXHGN7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 09:59:25 -0400
Received: from antonio.urjc.es ([193.147.184.24]:35229 "EHLO antonio.urjc.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761643AbXHGN7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 09:59:23 -0400
Message-ID: <46B87ACA.7010501@urjc.es>
Date: Tue, 07 Aug 2007 15:59:38 +0200
From: Javier Pello <javier.pello@urjc.es>
Organization: Universidad Rey Juan Carlos
User-Agent: Thunderbird 2.0.0.0 (X11/20070503)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH] request_firmware: skip timeout if userspace was not 
	notified
References: <46B37CF7.2020803@urjc.es> 
		<20070806142451.5d28d41c@gondolin.boeb lingen.de.ibm.com> 
		<46B7832B.6010808@urjc.es> <20070807125844.4d756b04@gondo 
		l	in.boeblingen.de.ibm.com> 
		<3ae72650708070446y6452d13jb7cd802119dab3ce@mail .gmail.com> 
		<20070807141030.1bb0f76a@gondolin.boeblingen.de.ibm.com> 
		<46B869C6.3090708@urjc.es> <1186491472.3611.33.camel@lov.localdomain>
In-Reply-To: <1186491472.3611.33.camel@lov.localdomain>
Content-Type: text/plain;
	charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender DNS name whitelisted, not delayed by 
	milter-greylist-2.0.2 (antonio.urjc.es [193.147.184.24]); Tue, 07 Aug 2007 
	15:59:12 +0200 (CEST)
X-imss-version: 2.047
X-imss-result: Passed
X-imss-scanInfo: M:B L:E SM:2
X-imss-tmaseResult: TT:1 TS:-13.7987 TC:04 TRN:33 TV:3.6.1039(15346.003)
X-imss-scores: Clean:100.00000 C:0 M:0 S:0 R:0
X-imss-settings: Baseline:1 C:1 M:1 S:1 R:1 (0.0000 0.0000)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Aug 2007, Kay Sievers wrote:

> If you don't have modules and the initial request fails, how do you
> load the firmware later?

I trigger a rebinding of the device to the driver in an init file:
# echo -n [device] >/sys/.../bind

> The real fix would be to change the driver not to block in the
> firmware request and use async version of firmware loading. The
> whole firmware class with its silly timeout is just a piece of
> crap, that needs to be replaced.

I don't think that would be a real fix. You've done away with the
kernel blocking, but the timeout is still there, only that in the
background, and my point is still true: it is useless to wait at
all if userspace didn't receive the event. Waiting asynchronously
is less annoying than waiting synchronously, but equally useless.

Javier


