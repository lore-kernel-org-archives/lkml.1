Return-Path: <linux-kernel-owner+w=401wt.eu-S932882AbXHFPC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882AbXHFPC0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 11:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764333AbXHFPCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 11:02:12 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:57485 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764321AbXHFPCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 11:02:09 -0400
X-Sasl-enc: GSituKHLgEUihN8+1s2k8huptdOeu3+1THrJs33jOqlR 1186412522
Date: Mon, 6 Aug 2007 12:01:59 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Michael Sedkowski <sedmich@gmail.com>
Cc: Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: Disk spin down issue on shut down/suspend to disk
Message-ID: <20070806150159.GC31615@khazad-dum.debian.net>
References: <838f88840708051428p3d65ff42w627af4bc38f57de3@mail.gmail.com> <46B6B006.6000100@gmail.com> <20070806142339.GA31615@khazad-dum.debian.net> <1186411815.4355.7.camel@nx6310>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186411815.4355.7.camel@nx6310>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Aug 2007, Michael Sedkowski wrote:
> Dnia 06-08-2007, Pn o godzinie 11:23 -0300, Henrique de Moraes Holschuh
> napisa??(a):
> > On Mon, 06 Aug 2007, Tejun Heo wrote:
> > > Cc'ing Henrique.  Any ideas?
> > 
> > Check if /etc/init.d/halt is calling halt(8) with the -h flag.  If it is,
> > remove that -h flag.  Usually, there is a hddown variable that holds it, you
> > just need to get rid of it.
> > 
> > I don't know anything about a Sidux, though.
> 
> Well there is an -h variable:
> # Don't shut down drives if we're using RAID.
> 	hddown="-h"
> 	if grep -qs '^md.*active' /proc/mdstat
> 	then
> 		hddown=""
> 	fi
> ....
> log_action_msg "Will now halt"
> 	halt -d -f $netdown $poweroff $hddown
> However removing it has no effect, the drive still spins down two times.

Nothing in Debian userspace will spin down the drive if you kill that -h, at
least as far as I know.

> Sidux is a Debian Unstable based distro with it's own set of patches
> including the shut down patch provided here:
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=426224

You'll probably have to ask Sidux what changes they made that could cause
the double spin down, even if halt(8) is never passed the -h flag.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
