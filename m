Return-Path: <linux-kernel-owner+w=401wt.eu-S1753816AbXCSMLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbXCSMLg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 08:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821AbXCSMLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 08:11:36 -0400
Received: from aun.it.uu.se ([130.238.12.36]:41663 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819AbXCSMLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 08:11:35 -0400
Date: Mon, 19 Mar 2007 13:11:05 +0100 (MET)
Message-Id: <200703191211.l2JCB5MU015419@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: alan@lxorguk.ukuu.org.uk, htejun@gmail.com
Subject: Re: [PATCH 2.6.22] Add LED trigger to libata core
Cc: chainsaw@gentoo.org, jgarzik@pobox.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007 12:46:16 +0000, Alan Cox wrote:
> > > This duplicates the IDE core LED trigger in the libata core.
> > > I plan to use this by allowing PMU LED control on G5 towers. My test platform 
> > > is a PowerMac 7,3 (Dual G5 2.0GHz, June 2004) with a K2 (sata_svw) controller.
> > 
> > I think this fits better in libata-core.c::ata_qc_issue().  Can you move
> > it to there?
> 
> Gak. I'd rather it stayed out of ata_qc_issue() which is a critical path
> for performance. Our command issu is already too heavy and not all
> controllers have queueing to absorb that. How many controllers actually
> need this hook and can we not have ata_qc_issue_with_led() helpers for
> them ?

Agreed, toggling a led for each request seems excessive.

At least Promise controllers tend to have a HW-driven
activity led header, so wouldn't need SW-triggered
activity leds except maybe if some stupid system failed
to wire up the led header.

/Mikael
