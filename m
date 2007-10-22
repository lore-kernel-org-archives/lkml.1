Return-Path: <linux-kernel-owner+w=401wt.eu-S1754088AbXJVLhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbXJVLhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 07:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbXJVLhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 07:37:43 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:59455 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbXJVLhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 07:37:41 -0400
Date: Mon, 22 Oct 2007 13:37:23 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: emist <emistz@gmail.com>
Cc: Linux <linux-kernel@vger.kernel.org>, geraldsc@de.ibm.com,
       cotte@de.ibm.com, linux390@de.ibm.com, linux-s390@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] Bug fix for the s390 dcssblk driver
Message-ID: <20071022133723.089b84db@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <471C1D29.5020403@gmail.com>
References: <200710201451.57138.elendil@planet.nl>
	<471A39D2.1070303@gmail.com>
	<20071021100926.GA4420@osiris.ibm.com>
	<471C1D29.5020403@gmail.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Oct 2007 23:46:49 -0400,
emist <emistz@gmail.com> wrote:

> # This patch fixes a memory corruption bug in the s390 dcssblk driver.
> # The bug occurs when an attempt to change the type of a segment
> # returns an error. At this point the driver tries to remove the segment in
> # question while some of the device's attributes are in use. This causes the
> # driver to hang.

Hm, seems we missed another of those device attributes exhibiting
suicidal tendencies...

Tejun has a patchset allowing device attributes to commit suicide (see
http://marc.info/?l=linux-kernel&m=119027371416452&w=2), although I'm
not sure what its current status is. Until then, you would need to use
device_schedule_callback() to commit suicide.

This all of course only applies if killing the segment is better than
leaving it in its current state, but others can make a better judgement
on that :)
