Return-Path: <linux-kernel-owner+w=401wt.eu-S1758598AbZCZPJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598AbZCZPJH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 11:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756890AbZCZPIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 11:08:55 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:60615
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756831AbZCZPIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 11:08:55 -0400
X-Greylist: delayed 739 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Mar 2009 11:08:54 EDT
Message-ID: <49CBA5DE.6050206@microgate.com>
Date: Thu, 26 Mar 2009 09:57:18 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Paul Rolland <rol@as2917.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.x - Serial port signalling not maintained when closing
 device
References: <20090326084220.4def5652@tux.DEF.witbe.net>
In-Reply-To: <20090326084220.4def5652@tux.DEF.witbe.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Rolland wrote:
> I'm using small devices that are connected on the serial port, and powered
> using RTS and DTR.
> When using kernel 2.4.x (at least 2.4.31), I could easily control the
> powering of the device using :
>  stty -F /dev/ttyS0 ospeed 9600 (this would put RTS and DTR to 1 / power)
> and
>  stty -F /dev/ttyS0 ospeed 0 (this would turn it off).
> 
> I've recently updated one of the machine to a new 2.6.29 kernel, and this
> is not working anymore.
> As far as I can see, I need to have an application that keeps /dev/ttyS0
> open for this to work. As soon as no application is using the port,
> everything goes down again.

Are you explicitly clearing the HUPCL flag?
(stty -F /dev/ttyS0 -hupcl)

I just did a quick test on 2.6.22 and DTR/RTS are maintained
with your commands above, but only after clearing HUPCL.

-- 
Paul Fulghum
MicroGate Systems, Ltd.
=Customer Driven, by Design=
(800)444-1982
(512)345-7791 (Direct)
(512)343-9046 (Fax)
Central Time Zone (GMT -5h)
www.microgate.com
