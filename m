Return-Path: <linux-kernel-owner+w=401wt.eu-S1753660AbYI3MgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbYI3MgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 08:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbYI3Mfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 08:35:52 -0400
Received: from cpsmtpo-eml06.kpnxchange.com ([213.75.38.155]:58685 "EHLO
	cpsmtpo-eml06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752435AbYI3Mfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 08:35:51 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Re: CD tray closes spontaneously after opening it
Date: Tue, 30 Sep 2008 14:35:48 +0200
User-Agent: KMail/1.9.9
Cc: Tony Vroon <tony@vroon.org>, Tejun Heo <tj@kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
References: <200809301247.05367.elendil@planet.nl> <1222773491.4003.2.camel@localhost> <200809301401.23160.elendil@planet.nl>
In-Reply-To: <200809301401.23160.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809301435.49512.elendil@planet.nl>
X-OriginalArrivalTime: 30 Sep 2008 12:35:49.0965 (UTC) FILETIME=[11EBFFD0:01C922F9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 September 2008, Frans Pop wrote:
> Hmm, in Debian unstable /etc/udev/rules.d/60-persistent-storage.rules
> also has:
> # skip removable ide devices, because open(2) on them causes an events
> loop KERNEL=="hd*[!0-9]", ATTR{removable}=="1",
> DRIVERS=="ide-cs|ide-floppy", \ GOTO="persistent_storage_end"
>
> I wonder if we've got a simple case of a typo here: ide-cs instead of
> ide-cd? However, there is such a thing as an ide-cs driver (legacy
> driver for PCMCIA IDE/ATA disk cards).
> But it does seem logical that rule should also cover IDE CDs...

Well, in upstream udev 128 the comment for that rule has been changed to:
# never access non-cdrom removable ide devices, the drivers are causing
# event loops on open()

So it looks like that's not it either.
