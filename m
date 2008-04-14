Return-Path: <linux-kernel-owner+w=401wt.eu-S1759773AbYDNHYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759773AbYDNHYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 03:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757541AbYDNHYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 03:24:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:46527 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756334AbYDNHYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 03:24:42 -0400
Subject: Re: [PATCH 1/3] PM: Introduce new top level suspend and
	hibernation callbacks (rev. 8)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Oliver Neukum <oliver@neukum.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200804140843.06088.oliver@neukum.org>
References: <200804040111.15255.rjw@sisk.pl>
	 <200804140309.22057.rjw@sisk.pl> <1208143380.6958.105.camel@pasglop>
	 <200804140843.06088.oliver@neukum.org>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 17:23:36 +1000
Message-Id: <1208157816.6958.133.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-04-14 at 08:43 +0200, Oliver Neukum wrote:
> 
> Which is the problem. Suspension is supposed to be transparent.
> We cannot start returning error codes for operations which never
> failed in practice (eg. switching configurations in USB), just because
> the system is about to be suspended.

Returning errors is better than crashing in any way. So what I meant
here is that the problem is not as bad as it sounds.

> If you want to request firmware in a PM callback, which makes a
> certain
> sense, as we should move to a comprehensive API, if we change the API
> at all, we need a model with 3 callbacks.

No. At this pace, we'll find reasons to have 98213674 callbacks and will
still not be happy.

Prepare() should be the right place to call request_firmware() and if
that is a problem because of bugs in some USB things, then those bugs
should be fixed.

Ben.


