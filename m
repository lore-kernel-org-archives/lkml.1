Return-Path: <linux-kernel-owner+w=401wt.eu-S1759958AbYAVIo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759958AbYAVIo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 03:44:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755187AbYAVIoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 03:44:18 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:64430 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbYAVIoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 03:44:17 -0500
Date: Tue, 22 Jan 2008 09:44:12 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: David Brownell <david-b@pacbell.net>, Greg KH <gregkh@suse.de>,
       stefanr@s5r6.in-berlin.de, James.Bottomley@hansenpartnership.com,
       a.zummo@towertech.it, peterz@infradead.org, cbou@mail.ru,
       linux-kernel@vger.kernel.org, stern@rowland.harvard.edu,
       dwmw2@infradead.org, davem@davemloft.net, jarkao2@gmail.com
Subject: Re: [PATCH 1/6] driver-core : add class iteration api
Message-ID: <20080122094412.18eab273@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20080122072708.GB3725@darkstar.te-china.tietoenator.com>
References: <20080112094754.GA2893@darkstar.te-china.tietoenator.com>
	<20080122055434.GB3066@darkstar.te-china.tietoenator.com>
	<200801212224.18149.david-b@pacbell.net>
	<20080122072708.GB3725@darkstar.te-china.tietoenator.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jan 2008 15:27:08 +0800,
Dave Young <hidave.darkstar@gmail.com> wrote:

> On Mon, Jan 21, 2008 at 10:24:17PM -0800, David Brownell wrote:
> > This is called with class->sem held.  So fn() has a
> > constraint to not re-acquire that ... else it'd be
> > self-deadlocking.  I'd like to see docs at least
> > mention that; calls to add or remove class members
> > would be verboten, for example, which isn't an issue
> > with most other driver model iterators.

Indeed, it's a good idea to point this out.

> Update kerneldoc as david brownell's sugestion.
> Is it right for me add Cornelia Huck's ack after this change?

Fine with me.

> ---
> 
> Add the following class iteration functions for driver use:
> class_for_each_device
> class_find_device
> class_for_each_child
> class_find_child
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 
> Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> 
> ---
>  drivers/base/class.c   |  175 +++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/device.h |   11 ++-
>  2 files changed, 184 insertions(+), 2 deletions(-)
