Return-Path: <linux-kernel-owner+w=401wt.eu-S1756942AbXHTKLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942AbXHTKLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 06:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbXHTKLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 06:11:40 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:55421 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752533AbXHTKLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 06:11:39 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: CONFIG_SUSPEND and power consumption
Date: Mon, 20 Aug 2007 12:11:34 +0200
User-Agent: KMail/1.9.7
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>
References: <20070819153259.2c96b904@hyperion.delvare> <200708192242.43819.rjw@sisk.pl> <20070820120258.7d090cc4@hyperion.delvare>
In-Reply-To: <20070820120258.7d090cc4@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708201211.34698.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 20 August 2007 schrieb Jean Delvare:
> If I rmmod "ehci-hcd" then the power consumption is back to 69 W. This
> confirms that this is really USB-related. I have to admit that I did
> not expect an external drive to eat that much power from the system,
> especially when not used. I am told that VIA chips are notoriously bad
> at this kind of things. I'll try the same external drive on an Intel
> system later today.
> 
> The last mystery remaining is how USB "activity" can cause my CPU to
> heat. I would expect the south bridge to heat, not the CPU.

USB, or strictly speaking EHCI, OHCI and UHCI, use DMA. To allow
that the cache coherency logic has to be active. Therefore your CPU
cannot go to C3. Therefore it draws more power. The problem we are
facing in USB is that to get great savings, our coverage has to be perfect.
One device that cannot be autosuspended and we lose most savings.

	Regards
		Oliver

