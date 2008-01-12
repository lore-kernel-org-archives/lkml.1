Return-Path: <linux-kernel-owner+w=401wt.eu-S1762311AbYALCs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762311AbYALCs5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 21:48:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760623AbYALCsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 21:48:06 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:55652 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760347AbYALCsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 21:48:03 -0500
X-Greylist: delayed 1450 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Jan 2008 21:48:03 EST
X-Sasl-enc: 02GM6QO+pIsUKQpdWB9DF3Hn1VhYvQtbiQmINPWnyc19 1200104631
Date: Sat, 12 Jan 2008 00:23:48 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Lenovo ThinkPads need acpi_osi="Linux"
Message-ID: <20080112022348.GC27524@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While helping a user find out what happened to his mute key, I found out
that the Lenovo BIOSes need the OSI string Linux defined to behave properly
in Linux.

Lenovo has been attempting to make things a bit easier for Linux on their
ThinkPads, by disabling the more obnoxious behaviours of the firmware (used
by their Windows drivers) when in Linux.  It looks like they used the OSI
string for that.

It is probably worthwhile to give a head's up: regressions involving
thinkpads and 2.6.23+ should probably have a 'please test with
acpi_osi="Linux"' step added if there is any chance ACPI AML code, BIOS or
SMBIOS code, or EC behaviour could be involved.

The most concrete example I have right now of changed behaviour is the Mute
key on the T61, which just plain disappears if acpi_osi="!Linux" (2.6.23
default).

I have also seen some hacked DSDTs around (mostly for older T4x models)
which used the Linux OSI string to fix or work around AML weirdness.  Those
would break in 2.6.23 (and 2.6.24?) as well.

Now, what should we do about it?  Add a quirk to always define the Linux OSI
string on ThinkPads (based on DMI information)?  All IBM ones (which won't
have BIOS revisions anymore, anyway) deal well with it, and Lenovo ones
seem to benefit from it.

We could also ask Lenovo to change the BIOS to stop paying attention to that
OSI string, but they will likely want/need a trigger for the AML code to
know it should change behaviour anyway, and the OSI string *does* look like
the proper thing to use IMHO.  I don't know if we could get them to arrive
to a behaviour that is acceptable both to us, and also to their Windows
drivers...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
