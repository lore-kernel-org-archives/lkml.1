Return-Path: <linux-kernel-owner+w=401wt.eu-S1753931AbZHKPx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbZHKPx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 11:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbZHKPx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 11:53:57 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34364 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752476AbZHKPx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 11:53:57 -0400
Date: Tue, 11 Aug 2009 11:53:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Zhang Rui <rui.zhang@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>,
       "dtor@mail.ru" <dtor@mail.ru>
Subject: Re: [PATCH V2 0/4] introduce device async actions mechanism
In-Reply-To: <200908111734.58949.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0908111148060.2562-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Aug 2009, Rafael J. Wysocki wrote:

> In fact, we don't need the layers at all.  The only thing we have to assure is
> that, during resume, the devices given device depends on will be handled
> before we start to handle this particular device (inversely during suspend).
> 
> Please note that we're not even allowed to start executing the device's
> resume callback before the callbacks of the devices it depends on have
> returned (the same applies to the suspend callbacks, but the other way around).

The general algorithm for maximum parallelism goes as follows: Start by
resuming (in parallel) all the devices which don't depend on anything
else.  Each time a resume finishes, you go on to resume (in parallel)
all the devices which depend only on resumed devices and which haven't
yet started to resume.

As described, this can require a large number of threads.  It also
requires detailed knowledge of which devices depend on others, which we
don't have.

Alan Stern

