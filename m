Return-Path: <linux-kernel-owner+w=401wt.eu-S1764345AbZCaXDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764345AbZCaXDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764339AbZCaXDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:03:00 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:33099 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761311AbZCaXC7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:02:59 -0400
From: Oliver Neukum <oliver@neukum.org>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/2 V2] kaweth: Fix locking to be SMP-safe
Date: Wed, 1 Apr 2009 01:06:10 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.29-9-default; KDE/4.1.3; x86_64; ; )
Cc: Larry.Finger@lwfinger.net, jgarzik@pobox.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
References: <49d264dd.YwbXLw18YaD1tQqD%Larry.Finger@lwfinger.net> <200904010013.05494.oliver@neukum.org> <20090331.151028.42671906.davem@davemloft.net>
In-Reply-To: <20090331.151028.42671906.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904010106.10974.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 01 April 2009 00:10:28 schrieb David Miller:
> > Here you enable interrupts. Are you sure ndo_start_xmit is never
> > called with interrupts disabled?
>
> It must never be invoked that way, this would break so many
> drivers.
>
> On the other hand, all of these driver paths never execute
> in a real hardware interrupt context, the deepest it gets
> into is software interrupts.  So spin_*lock*_bh() might be
> more appropriate.

Thanks. The patch is good. I'll check the other USB network
drivers.

	Regards
		Oliver

