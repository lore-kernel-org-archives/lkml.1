Return-Path: <linux-kernel-owner+w=401wt.eu-S933224AbXIJWwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933224AbXIJWwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 18:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965314AbXIJWwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 18:52:11 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:53051 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965181AbXIJWwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 18:52:09 -0400
X-Sasl-enc: Weip5L979MGUOF/jBSBv/9OHhGHLagCz9WqszJmpFBX2 1189464727
Date: Mon, 10 Sep 2007 19:52:05 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jean Delvare <khali@linux-fr.org>
Cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, dmitry.torokhov@gmail.com
Subject: Re: Platform device id
Message-ID: <20070910225205.GB1408@khazad-dum.debian.net>
References: <20070907153559.17faf9d1@hyperion.delvare> <d120d5000709070758i1b54a37o3d3977304a84b2c1@mail.gmail.com> <20070907164129.65816B9389@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <20070907210029.GB4357@khazad-dum.debian.net> <20070907214116.5051B237214@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <20070907220407.GE4357@khazad-dum.debian.net> <20070908001835.C7F721B729B@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <20070908035022.GF4357@khazad-dum.debian.net> <20070908105534.2e8e7d8a@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070908105534.2e8e7d8a@hyperion.delvare>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 08 Sep 2007, Jean Delvare wrote:
> This more general than just the platform bus. It's how the Linux 2.6
> device driver model is designed.

No issues about that.  It is just that the platform bus sucks a bit if you
need to "abuse it" (no wonder!) to hang various different devices that are
provided *or* driven by the same module.

> There are alternatives to the way hdaps and thinkpad_acpi instantiate
> their devices:
> 

> * These drivers use DMI to find out whether they run on supported
> hardware. The same detection code could be moved to a separate driver

Actually, DMI is a hint for autoloading, only.  They do probe the
hardware/firmware for the needed functionality to know for sure.

> (possibly the same one for all DMI-detected devices) and that separate
> driver would instantiate the devices as needed. Then the usual
> hotplug/coldplug rules apply.

That could work, yes.

> * Detection could be moved to user-space entirely, then we would only
> need a way to instantiate these specific devices from user-space. This
> exists in other areas (scsi, network) for quite some times already so
> it shouldn't be too difficult.

Don't like that one, sorry.  Detection often needs the kind of access to
hardware that is better off contained in the kernel.

> > 2. The fact that a module that has a number of different devices has to
> >    register itself a number of times as a driver, if it wants to name the
> >    devices something different...
> 
> Sounds like you have a design issue here to start with. Supporting
> several significantly different devices in the same module is not
> something that we do usually.

I will see what I can do about breaking it up in various modules.  But this
can be unoptimal. If I took it too seriously, thinkpad-acpi would break into
at least five different modules, if not more, and at least one or two
modules would need to be there for the common code.  There has to be a
middle ground somewhere, I think.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
