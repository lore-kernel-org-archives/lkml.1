Return-Path: <linux-kernel-owner+w=401wt.eu-S1758892AbYCEQQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892AbYCEQQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 11:16:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754787AbYCEQQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 11:16:41 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:14643 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbYCEQQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 11:16:39 -0500
Date: Wed, 5 Mar 2008 17:16:29 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [RFC][PATCH] PM: Make PM core handle device registrations
 concurrent with suspend/hibernation
Message-ID: <20080305171629.6853c454@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <Pine.LNX.4.44L0.0803051050310.4621-100000@iolanthe.rowland.org>
References: <200803042252.51440.rjw@sisk.pl>
	<Pine.LNX.4.44L0.0803051050310.4621-100000@iolanthe.rowland.org>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2008 11:03:52 -0500 (EST),
Alan Stern <stern@rowland.harvard.edu> wrote:

> There might still be logical problems, of course...  We need to add a
> mechanism for reordering the dpm_active list when device_move() is
> called.  But first we need to get in touch with the people using
> device_move() -- basically just Marcel and Cornelia -- and see what
> sort of mechanism they will need.

On s390 we currently don't do anything suspend related at all - I'd
need to think about that. (I use device_move() to reflect topology
changes on the (virtual) hardware, so I'd guess the "don't suspend
parent before child rule" should still apply afterwards. But of course,
that also depends on what we actually need to do on the parent's bus and
what on the child's bus.)
