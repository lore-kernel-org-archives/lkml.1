Return-Path: <linux-kernel-owner+w=401wt.eu-S1757974AbXHPMZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974AbXHPMZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 08:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753983AbXHPMZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 08:25:13 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:42078 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753607AbXHPMZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 08:25:10 -0400
X-Sasl-enc: BTKaHzxxmYdEEMv16TIlS5PVOawVYUWdP2vM9K3ij5Sg 1187267109
Date: Thu, 16 Aug 2007 09:25:06 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Cc: lenb@kernel.org, Hugh Dickins <hugh@veritas.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Richard Hughes <hughsient@gmail.com>
Subject: Re: [PATCH 3/3] ACPI: thinkpad-acpi: change thinkpad-acpi input
	default and kconfig help
Message-ID: <20070816122506.GA5081@khazad-dum.debian.net>
References: <11868017142597-git-send-email-hmh@hmh.eng.br> <11868017143582-git-send-email-hmh@hmh.eng.br> <20070811180602.GA17843@mellanox.co.il> <20070811221625.GB27761@khazad-dum.debian.net> <20070816073053.GA19833@mellanox.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070816073053.GA19833@mellanox.co.il>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Aug 2007, Michael S. Tsirkin wrote:
> > I *can* make the compile-time option a module parameter, though.  That
> > wouldn't be much of a problem, and the compile-time option would select the
> > default for that parameter, but it would be easier to override it at run
> > time (you can already do it, but it requires reprogramming various driver
> > parameters using sysfs and the input device IOCTLs).
> > 
> > Would a module parameter address enough of your concerns?  Kconfig would
> > only set the default for that parameter, then...
> 
> I really think modifying defaults it not a great idea.
> What about adding a writeable module parameter?
> Then new HAL would just write to /sysfs/module/thinkpad/parameters/interface_version to 
> switch to new behaviour.

Nah. This thing regulates what the module has to do when it loads and inits
the firmware, and the whole point of the new behaviour is to get userspace
to be as hands' off as possible, so that we can auto-tune things better
in-kernel, without a need to worry about HAL and friends overwriting local
admin configurations needlessly.

I will probably have to do something like the strict versioned interfaces of
wireless extensions, I think.  It really is a case of a deprecation of
current userland interfaces done sanely.  Right now I am thinking about
giving userland two kernel releases before I change the default interface
level, and one to two years to remove the older ones.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
