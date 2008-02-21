Return-Path: <linux-kernel-owner+w=401wt.eu-S935553AbYBUXRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935553AbYBUXRq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 18:17:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935199AbYBUXR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 18:17:29 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45552 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935192AbYBUXR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 18:17:28 -0500
Message-ID: <47BE06EB.6010301@firstfloor.org>
Date: Fri, 22 Feb 2008 00:19:07 +0100
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: Simon Richter <sjr@debian.org>, Tilman Schmidt <tilman@imap.cc>,
       Gregory Nietsky <gregory@networksentry.co.za>,
       Jeff Garzik <jeff@garzik.org>, kkeil@suse.de, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Plans for mISDN? Was: [PATCH 00/14] [ISDN] ...
References: <098123kjff90231nv098233rnvd908u234@garzik.org>	<20080217195235.GN14588@uranus.ravnborg.org>	<20080218045209.GA15141@kroah.com> <p73zltyxy9q.fsf@bingen.suse.de>	<20080219085033.GA1775@uranus.ravnborg.org>	<47BAA072.9050601@networksentry.co.za> <47BC370F.3000705@imap.cc> <47BD5360.5070706@debian.org> <AC06F991-72AC-4DFB-825A-F046C1943F10@holtmann.org>
In-Reply-To: <AC06F991-72AC-4DFB-825A-F046C1943F10@holtmann.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> that is not a big problem at all. If you have to enforce a specific
> module load order then create some dummy exports like misdn_load() and
> use them from the module that depends on it.

That's not necessarily enough. There are races during module load
when the next module is loaded already before the module it depends
on has finished initializing.

I regularly run into such a problem on my workstation with one
of the USB serial drivers for example. It errors out when autoloaded
during boot, but loads fine on retry later.

-Andi
