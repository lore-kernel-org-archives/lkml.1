Return-Path: <linux-kernel-owner+w=401wt.eu-S1757536AbYGTNwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536AbYGTNwz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 09:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbYGTNwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 09:52:47 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:47663 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752259AbYGTNwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 09:52:46 -0400
X-Sasl-enc: 4XEGvTNIFoElEpnw1ObHDwAXY4ybjlAFgkGr2iq1S9ap 1216561964
Date: Sun, 20 Jul 2008 10:52:39 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Philip Langdale <philipl@overt.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       toshiba_acpi@memebeam.org, randy.dunlap@oracle.com
Subject: Re: [PATCH] toshiba_acpi: Add support for bluetooth toggling
	through rfkill
Message-ID: <20080720135239.GA14801@khazad-dum.debian.net>
References: <488256C1.6040802@overt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488256C1.6040802@overt.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Jul 2008, Philip Langdale wrote:
> sets up an rfkill device and a polled input device to track the state of the
> hardware kill-switch. One entertaining fact about these Toshibas is that the
[...]

Soft NAK.

Please have a look at rfkill in wireless-testing (it is going in with the
merge of the net tree, so it will be in mainline really soon).  rfkill has
seen some changes, and no little ammount of that work was to make platform
drivers like thinkpad-acpi and toshiba-acpi work better with rfkill.  The
documentation in Documentation/rfkill.txt was expanded and improved as well,
and will help you get a better picture of how it should work.  The rfkill
changes should also be available in wireless-compat, and they are
backport-friendly.

Please consider updating your patch to the new style rfkill class.  A quick
look at your patch shows that it would benefit from the new
RFKILL_STATE_HARD_BLOCKED, and maybe to some rework to separate the
bluetooth rfkill controller and the input device switch better.  Depending
on the existence of ACPI GPE events when the switch changes state on
Toshibas, you may even be able to get rid of some of the polling...

If you rework/repost your patch, please CC Ivo (the rfkill maintainer) and
the linux-wireless mailing list.  If you want me to try to help review the
patch as well, please also add me to the CC.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
