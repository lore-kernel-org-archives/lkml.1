Return-Path: <linux-kernel-owner+w=401wt.eu-S1759815AbYD3Ov0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759815AbYD3Ov0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 10:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758005AbYD3OvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 10:51:14 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:34584 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756765AbYD3OvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 10:51:13 -0400
X-Sasl-enc: WPbemviR1HEqBqNZHVDqBS0ZkwR40A8jjkCHx8KBMN/e 1209567072
Date: Wed, 30 Apr 2008 11:51:10 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jean Delvare <khali@linux-fr.org>
Cc: Kasper Sandberg <lkml@metanurb.dk>, Rudolf Marek <r.marek@assembler.cz>,
       Maxim Levitsky <maximlevitsky@gmail.com>, trenn@suse.de,
       Len Brown <lenb@kernel.org>, Matthew <jackdachef@gmail.com>,
       linux-acpi@vger.kernel.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Zhang, Rui" <rui.zhang@intel.com>
Subject: Re: Linux 2.6.25 (coretemp reads high temperatures)
Message-ID: <20080430145110.GC3543@khazad-dum.debian.net>
References: <e85b9d30804180837y39c52e26i588e4b67c87a5e9d@mail.gmail.com> <200804182151.49021.lenb@kernel.org> <200804231143.10875.maximlevitsky@gmail.com> <1209406784.11608.15.camel@localhost> <1209474423.1784.837.camel@queen.suse.de> <20080429170824.09540206@hyperion.delvare> <48179DB4.8040701@assembler.cz> <1209514274.27499.12.camel@localhost> <20080430082005.4b76186f@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080430082005.4b76186f@hyperion.delvare>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008, Jean Delvare wrote:
> On Wed, 30 Apr 2008 02:11:14 +0200, Kasper Sandberg wrote:
> > On Wed, 2008-04-30 at 00:14 +0200, Rudolf Marek wrote:
> > > Well again, I tried hard at Intel and I really could not get any info on some
> > > calibration bit. The temperature is non-physical on arbitrary scale. I changed
> > > that so for some people it jumped to 100C, for some it remained.
> > 
> > So, im confused.. The reason for this is that the internal sensor is
> > operating on some sort of weird scale, and thus when you interpolate it
> > into "your" scale, it doesent quite come out in the actual degrees
> > celcius the cpu temperature really is?
> 
> It's really only an offset, rather than scaling. The temperature
> reported by the Core and Core2 CPUs is a relative temperature. It tells
> how far you are from the maximum temperature the CPU can survive. The
> value is expressed in (relative) degrees C.

Ah, please ignore my email about ITUs (Intel thermal units), then.  The
above means 1ITU=1°C, but their zeros are at different places.

> Rudolf did his best to find out the (absolute) temperature each CPU
> model can survive (known as TJmax) so that the coretemp driver can
> provide an absolute temperature to user-space, as all other hardware
> monitoring drivers do. Our hope was to limit the confusion, but it
> seems we failed ;) Maybe it would be better if the driver was reporting
> the relative temperature value directly when we don't know the TJmax
> value for sure - but then all user-space tools would need to learn how
> to deal with this.

Actually, just libsensors would, and the local admin can adjust it at
will using the config file.

Nobody in userspace should be reading hwmon sysfs directly without the
use of libsensors.  If they are, it is their bug, and it is unsupported
AFAIK.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
