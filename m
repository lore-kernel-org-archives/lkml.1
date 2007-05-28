Return-Path: <linux-kernel-owner+w=401wt.eu-S1757426AbXE1Lwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426AbXE1Lwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 07:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbXE1Lwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 07:52:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56971 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbXE1Lwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 07:52:42 -0400
Subject: Re: [RFC][PATCH -mm 3/3] PM: Disable _request_firmware before
	hibernation/suspend
From: Kay Sievers <kay.sievers@vrfy.org>
To: Michael-Luke Jones <mlj28@cam.ac.uk>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Alan Stern <stern@rowland.harvard.edu>
In-Reply-To: <6BFA837E-47D4-487F-9D71-FA83D6D865E5@cam.ac.uk>
References: <200705272229.21263.rjw@sisk.pl>
	 <20070527220412.GC22687@srcf.ucam.org>
	 <1180304166.3131.66.camel@lov.localdomain> <200705280943.54312.rjw@sisk.pl>
	  <20070528111554.GF18807@elf.ucw.cz>
	 <1180351493.4242.31.camel@lov.localdomain>
	 <6BFA837E-47D4-487F-9D71-FA83D6D865E5@cam.ac.uk>
Content-Type: text/plain
Date: Mon, 28 May 2007 13:51:35 +0200
Message-Id: <1180353095.4242.57.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/YPjrasuGvLb43r/o7l2oMb1zE688YiVE9lFl
 u0GiKhEuF9qXffN9exeYLpC/ho3VvoNI4pv/uKrrGl+V05ZUC/
 ReJVgQTVQcjLQcbKWA7GRyeiLzTxx1t
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-28 at 12:38 +0100, Michael-Luke Jones wrote:
> On 28 May 2007, at 12:24, Kay Sievers wrote:
> 
> > A driver for a bootup-critical device like this should just never
> > release the firmware after the first load. There is absolutely no  
> > point
> > in doing that.
> 
> Bogus argument: is a USB-Ethernet device which needs firmware loading  
> boot-up critical? Not on the surface, but if the device loads root  
> over this device, it suddenly is.

Releasing loaded firmware for anything that needs to handle situations
like this just doesn't make sense.

> This functionality should also be written into the firmware-class  
> (and this fact *is* acknowledged in the sparse documentation).

Yeah, but these are just words, nothing people could use. Unfortunately
the author of this document died a few years ago.

Either the whole idea of userspace firmware-loading should be considered
as a problem impossible to do right because of its unsolvable side
effects. Or at least releasing loaded firmware should be the exception
for drivers which can be sure, that the firmware is not needed in
situations we try to work around here.

Kay

