Return-Path: <linux-kernel-owner+w=401wt.eu-S937464AbXHIJNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937464AbXHIJNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 05:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765986AbXHIJNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 05:13:13 -0400
Received: from antonio.urjc.es ([193.147.184.24]:53446 "EHLO antonio.urjc.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765290AbXHIJNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 05:13:12 -0400
Message-ID: <46BADAA8.70404@urjc.es>
Date: Thu, 09 Aug 2007 11:13:12 +0200
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
		<46B87ACA.7010501@urjc.es> <1186495705.3611.39.camel@lov.localdomain>
In-Reply-To: <1186495705.3611.39.camel@lov.localdomain>
Content-Type: text/plain;
	charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender DNS name whitelisted, not delayed by 
	milter-greylist-2.0.2 (antonio.urjc.es [193.147.184.24]); Thu, 09 Aug 2007 
	11:13:05 +0200 (CEST)
X-imss-version: 2.047
X-imss-result: Passed
X-imss-scanInfo: M:B L:E SM:2
X-imss-tmaseResult: TT:1 TS:-8.5279 TC:1F TRN:36 TV:3.6.1039(15350.003)
X-imss-scores: Clean:100.00000 C:0 M:0 S:0 R:0
X-imss-settings: Baseline:1 C:1 M:1 S:1 R:1 (0.0000 0.0000)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Aug 2007, Kay Sievers wrote:
> Nope, you would just fulfill in a completely generic way all outstanding
> requests when you are ready. All requests are all nicely grouped and
> visible in sysfs. There would be no need of coding your own device
> specific rebind. No timeout is needed or wanted, all requests would stay
> until userspace has handled them successfully or canceled them.

If I'm not mistaken, as it is now, requests are not grouped in any way.
The only hint that a firmware loading request is in progress are a couple
of files in the device directory in sysfs. Should I run, at boot, through
all the device directories to check which firmware requests are pending?

Also, this could pose problems if two drivers can handle a device but
the first that gets to bind to it needs firmware and userspace doesn't
provide it or cancel the loading. The device will remain bound without
giving the other driver a chance to handle it.

Anyway, I think something must be done, either removing the timeout and
making all firmware requests asynchronous, or at least skipping the
delay when we're sure that it's useless.

Javier


