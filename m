Return-Path: <linux-kernel-owner+w=401wt.eu-S1756613AbYFOXpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613AbYFOXpe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 19:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbYFOXpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 19:45:24 -0400
Received: from relay.thorn.net ([216.213.0.103]:63252 "EHLO relay.thorn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbYFOXpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 19:45:24 -0400
X-Greylist: delayed 1821 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Jun 2008 19:45:24 EDT
Date: Sun, 15 Jun 2008 19:16:09 -0400
Message-Id: <200806152316.m5FNG9E3006939@Ettarre>
To: linux-kernel@vger.kernel.org
From: jmcgowan@inch.com
Subject: minicom and kernel 2.6.25.1 (at least) (DTR)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MINICOM AND KERNEL 2.6.25.1
===========================
Minicom drops DTR in two places (that I see).

*If there is an initialization string configured for the modem*
when starting, or when the option to (re)initialize the modem
is selected, minicom drops DTR, bring DTR up again and sends the
initialization string.

Minicom can be configured to hang-up either by dropping DTR
and bringing it up again a few seconds later (the time delay
being configurable) (this is the default) or not to drop DTR
but to use the Hayes's command string, "+++ATH".

This works in kernel 2.6.24. On my system with kernel 2.6.25.1
(and kernel 2.6.24) minicom can not bring up DTR after dropping
it, the result being that, *if a modem configuration string is set,*
upon starting, it drops DTR and that stays down - the modem is
dead until minicom is restarted. If one starts minicom with the
"-o" switch (to prevent it from initializing the modem) and makes
a call and hangs up using the default or used the option to
initialize the modem then the modem is dead until minicom is
restarted.

WORK AROUND FOR KERNEL 2.6.25.1
-------------------------------
Either start minicom with the "-o" switch (and don't use the option
to initialize the modem) or remove the initialization string
(if that string is null it seems that minicom doesn't drop DTR) and
configure minicom not to drop DTR but to use the Hayes's command
to hang up. If one needs to set some parameters in the modem (and
does not want to use its flash ram to save it as the new default)
either manually enter the Hayes's commands one minicom has started
or write a script to enter them - but a script, not something
minicom recognizes as "initializing the modem", so minicom does not
drop DTR when sending the commands to the modem.

