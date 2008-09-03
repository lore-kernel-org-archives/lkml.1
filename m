Return-Path: <linux-kernel-owner+w=401wt.eu-S1753528AbYICQ0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbYICQ0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 12:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbYICQ0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 12:26:47 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:61956 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbYICQ0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 12:26:46 -0400
Date: Wed, 3 Sep 2008 18:26:37 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg K-H <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [Patch 0/2] Driver core: device_register() and put_device()
Message-ID: <20080903182637.50bec6fd@gondolin.boeblingen.de.ibm.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

recently I stumbled over a bug in my code where I called kfree() on a
device after device_register() had been called (instead of using
put_device()). This seems to be a trap that is easily hit, so I added
some clarifications to the docbook comments for the device registration
functions. Looking further at the driver core code, I found that
device_create_vargs() contains the same bug.

The patches are on top of the driver core quilt.

[Patch 1/2] Driver core: Clarify device cleanup.
[Patch 2/2] Driver core: Fix cleanup in device_create_vargs().
