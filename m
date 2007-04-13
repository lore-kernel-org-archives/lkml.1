Return-Path: <linux-kernel-owner+w=401wt.eu-S1030843AbXDMVl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030843AbXDMVl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 17:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030845AbXDMVl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 17:41:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030843AbXDMVlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 17:41:25 -0400
Message-ID: <461FF8E5.7010202@redhat.com>
Date: Fri, 13 Apr 2007 17:40:53 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: nigel@nigel.suspend2.net, Pavel Machek <pavel@ucw.cz>,
       Jiri Slaby <jirislaby@gmail.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org
Subject: Re: [RFD] swsusp problem: Drivers allocate much memory during suspend
References: <460B6E4B.3060004@gmail.com> <200704131400.12021.rjw@sisk.pl> <1176466896.7112.159.camel@nigel.suspend2.net> <200704132241.52725.rjw@sisk.pl>
In-Reply-To: <200704132241.52725.rjw@sisk.pl>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> 
> IMO to really fix the problem, we should let the drivers that need much memory
> for suspending allocate it _before_ the memory shrinker is called.  For this
> purpose we can use notifiers that will be called before we start the shrinking
> of memory.  Namely, if a driver needs to allocate substantial amount of memory
> for suspending, it can register a notifier that will be called before we try to
> shrink memory.  Then, the memory needed by the driver may be allocated in
> this notifier (of course, in that case it will also have to be called if the
> shrinking of memory fails, so that the memory allocated by the driver for
> suspending can be freed) and used in the driver's .suspend() routine.
> 

Can't you just put a "prepare to suspend" function pointer in the
bus_type and device_driver structs?

