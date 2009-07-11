Return-Path: <linux-kernel-owner+w=401wt.eu-S1753016AbZGKSyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbZGKSyh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 14:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbZGKSya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 14:54:30 -0400
Received: from senator.holtmann.net ([87.106.208.187]:41390 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbZGKSy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 14:54:29 -0400
Subject: Re: rfkill rework in 2.6.31-rc, hal/dbus access changes?
From: Marcel Holtmann <marcel@holtmann.org>
To: Norbert Preining <preining@logic.at>
Cc: linux-kernel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <20090711091427.GB14367@gamma.logic.tuwien.ac.at>
References: <20090711091427.GB14367@gamma.logic.tuwien.ac.at>
Content-Type: text/plain
Date: Sat, 11 Jul 2009 11:54:33 -0700
Message-Id: <1247338473.9709.107.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Norbert,

> I have written a Gnome applet for turning off and on the various
> hardware items using the rfkill interface. It was working very well on
> up to 2.6.30. With 2.6.31-rc that infrastructure has been changed, and
> now no access mode I know of still works.
> 
> - formerly writing 0 or 1 to /sys/class/rfkill/rfkillN/state worked, now
>   it returns access denied.

actually Johannes sent a patch to fix this. It will still return an
error if the RFKILL switch is hard-blocked btw.

> - access via Hal/Dbus (what I am doing) stopped working, too

Not the first time HAL broke in this area, because its RFKILL support is
a bunch of hacked up scripts. Send a patch to the HAL mailing list.

> In the Documentation I only see reference to /dev/rfkill, which isn't a
> usefull access method because for the applet to work for every user
> (based on the permissions of hal) we need hal/dbus access.

You could just go ahead and work on fixing HAL.

> Is this intended behaviour? Is there any other documentation but the
> very short rfkill.txt in the kernel's Documentation?

Changing RFKILL soft-block via the state file got fixed, but it is still
a total broken interface. If you rely on it (directly or via HAL) your
application is useless. And if you are polling the state of the RFKILL
switches via HAL, then your application is even worse. You need to
wake-up too often to actually see RFKILL state changes.

The /dev/rfkill interface is the only way to get a proper interface with
all RFKILL switches in your system. And this includes enumeration, async
notification and changing states on a per technology basis.

Regards

Marcel


