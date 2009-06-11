Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770AbZFKN5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbZFKN5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 09:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbZFKN5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 09:57:03 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:39265 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbZFKN5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 09:57:02 -0400
From: Oliver Neukum <oliver@neukum.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch update] Re: [linux-pm] Run-time PM idea (was: Re: [RFC][PATCH 0/2] PM: Rearrange core suspend code)
Date: Thu, 11 Jun 2009 15:57:48 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.30-rc7-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       linux-pm@lists.linux-foundation.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0906101942280.29717-100000@netrider.rowland.org> <200906111548.33751.rjw@sisk.pl>
In-Reply-To: <200906111548.33751.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906111557.49490.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 11. Juni 2009 15:48:33 schrieb Rafael J. Wysocki:
> > > But after pm_request_resume() returns there's no means to make sure
> > > nothing alters it back to RPM_SUSPENDED. The workqueue doesn't help
> > > you because you've scheduled nothing by that time. The suspension will
> > > work because C is still in RPM_SUSPENDED.
> >
> > This is an example where usage counters come in handy.
>
> Do you mean we can count suspend/resume requests for a device?

No, we count reasons a device cannot be suspended. Drivers are allowed to
add their own reasons. The core uses that mechanism to indicate that an
ongoing resumption lower down is also a reason.
The count going to zero is equivalent to a request to suspend.

	Regards
		Oliver

