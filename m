Return-Path: <linux-kernel-owner+w=401wt.eu-S1760850AbXE1Pzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760850AbXE1Pzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 11:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbXE1PzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 11:55:25 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4521 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751211AbXE1PzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 11:55:24 -0400
Date: Mon, 28 May 2007 11:55:22 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC][PATCH -mm 3/3] PM: Disable _request_firmware before
 hibernation/suspend
In-Reply-To: <200705272231.54535.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0705281151250.22682-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 May 2007, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Use a hibernation and suspend notifier to disable the firmware requesting
> mechanism before a hibernation/suspend and enable it after the operation.

You're using the PM_PRE_FREEZE and PM_POST_THAW notifiers for both this 
and the userspace helper change.  Is it your intention that drivers 
should continue to request these services but encounter an error if the 
request occurs at the wrong time?  Or do you expect drivers to use the 
notifier chains to know when they shouldn't make any requests?

In the second case you may have a problem, because there's no 
specification about the order in which the notifiers are sent.  The 
service may get disabled before the driver learns it isn't available, 
or the driver may think the service is once again available before it 
gets enabled.

Alan Stern

