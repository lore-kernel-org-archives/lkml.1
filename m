Return-Path: <linux-kernel-owner+w=401wt.eu-S1753535AbZJGUcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbZJGUcG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 16:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbZJGUcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 16:32:05 -0400
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:47893
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752302AbZJGUcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 16:32:05 -0400
Date: Wed, 7 Oct 2009 22:31:21 +0200
From: Michael Guntsche <mike@it-loops.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-hotplug <linux-hotplug@vger.kernel.org>
Subject: Re: [BUG] No ttyS0 - Strange udev 8250_pnp interaction
Message-ID: <20091007203121.GA432@trillian.comsick.at>
References: <20091007175403.GA335@trillian.comsick.at>
 <9b2b86520910071246r393f2afvacaa4d8f544508a8@mail.gmail.com>
 <ac3eb2510910071306r4ad6dc9btb7503bc3ab0ec815@mail.gmail.com>
 <ac3eb2510910071312qe6ad45ep6c579a8393cc6b8e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510910071312qe6ad45ep6c579a8393cc6b8e@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009.10.07 22:12:28 , Kay Sievers wrote:
> To be more specific, Michael, can you please run "udevadm monitor" at
> the same time you see this happen?

I started udevadm monitor with the module installed AND all 4 devices
populated. Then I removed the module....

KERNEL[1254947142.220060] remove   /devices/pnp0/00:06/tty/ttyS1 (tty)
UDEV  [1254947142.220121] add
/devices/platform/serial8250/tty/ttyS1 (tty)
KERNEL[1254947142.220161] add
/devices/platform/serial8250/tty/ttyS1 (tty)
UDEV  [1254947142.220857] remove   /devices/pnp0/00:06/tty/ttyS1 (tty)
KERNEL[1254947142.223078] remove   /devices/pnp0/00:05/tty/ttyS0 (tty)
UDEV  [1254947142.223134] add
/devices/platform/serial8250/tty/ttyS0 (tty)
KERNEL[1254947142.223175] add
/devices/platform/serial8250/tty/ttyS0 (tty)
UDEV  [1254947142.223800] remove   /devices/pnp0/00:05/tty/ttyS0 (tty)
KERNEL[1254947142.225369] remove   /bus/pnp/drivers/serial (drivers)
UDEV  [1254947142.225419] remove   /module/8250_pnp (module)
KERNEL[1254947142.225455] remove   /module/8250_pnp (module)
UDEV  [1254947142.225675] remove   /bus/pnp/drivers/serial (drivers)

Afterwards ONLY ttyS2 and ttS3 were under /dev. 

I then added the module again ....

KERNEL[1254947157.330470] add      /module/8250_pnp (module)
UDEV  [1254947157.330521] add      /module/8250_pnp (module)
KERNEL[1254947157.333498] remove
/devices/platform/serial8250/tty/ttyS0 (tty)
KERNEL[1254947157.333550] add      /devices/pnp0/00:05/tty/ttyS0 (tty)
UDEV  [1254947157.334830] add      /devices/pnp0/00:05/tty/ttyS0 (tty)
UDEV  [1254947157.334889] remove
/devices/platform/serial8250/tty/ttyS0 (tty)
KERNEL[1254947157.338967] remove
/devices/platform/serial8250/tty/ttyS1 (tty)
KERNEL[1254947157.339020] add      /devices/pnp0/00:06/tty/ttyS1 (tty)
KERNEL[1254947157.339056] add      /bus/pnp/drivers/serial (drivers)
UDEV  [1254947157.340180] remove
/devices/platform/serial8250/tty/ttyS1 (tty)
UDEV  [1254947157.340753] add      /devices/pnp0/00:06/tty/ttyS1 (tty)
UDEV  [1254947157.341202] add      /bus/pnp/drivers/serial (drivers)

ONLY ttyS1 (and S2, S3) where there.

Kind regards,
Michael
