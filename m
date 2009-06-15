Return-Path: <linux-kernel-owner+w=401wt.eu-S1753056AbZFOCCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbZFOCCg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 22:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750941AbZFOCC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 22:02:29 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:56001 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750838AbZFOCC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 22:02:28 -0400
X-Sasl-enc: BU5S4WXngwIHvaDSeeHrQxZqgTnEelVgzFGmOOXLHbcA 1245031349
Date: Sun, 14 Jun 2009 23:02:26 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Joerg Platte <jplatte@naasa.net>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6.30] Kernel bug with dock driver
Message-ID: <20090615020226.GA30720@khazad-dum.debian.net>
References: <200906142100.48621.jplatte@naasa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906142100.48621.jplatte@naasa.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Jun 2009, Joerg Platte wrote:
> The bug message appears with a high probability - but not always -
> when I release the eject lever to exchange the drive in the ultrabay
> slot. I'm not sure if this bug is a regression of 2.6.30, because I
> did not change the drive in the ultrabay for several months. Maybe it
> was already in 2.6.29 or before.  How can I help to resolve this bug?

Do it in single user mode with udev helpers *killed*, but just release
the lever, _don't_ pull the drive off the bay, unless you do verify that
the bay LED went off.

***NEVER*** remove an Ultrabay device with the Ultrabay LED still lit,
especially if it is a PATA device.

If the bug cannot be reproduced in that condition, it is happening
because userspace is trapping the lever release event (as it should),
and doing something the kernel doesn't like with it (which is a bug
in the kernel in any case).  That might help you track down a better
way to reproduce the issue.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
