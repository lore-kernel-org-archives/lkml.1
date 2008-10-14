Return-Path: <linux-kernel-owner+w=401wt.eu-S1757712AbYJNJPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712AbYJNJPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 05:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757398AbYJNJPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 05:15:17 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:40457 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726AbYJNJPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 05:15:15 -0400
Message-Id: <20081014091247.433079967@linux.vnet.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 14 Oct 2008 11:12:47 +0200
From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux PPC devel <linuxppc-dev@ozlabs.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Ryan S. Arnold" <rsa@us.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [RFC PATCH 0/5] patches for a network-based hvc backend (s390)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I work on a network-based hvc console backend for s390 that allows
to get "full-screen" terminal access to z/VM guest machines.
The solution consists of a HVC backend that provides the terminal interface;
and a tool to connect to the terminal via a z/VM specific communication
protocol.

The network-based backend differs in a few aspects from the notifier-based
model of the HVC console; because it has to deal with (dis)connects and must
take care of virtual tty hangups. Therefore, I would like to introduce a third
notifier for hangups (see patch 1).

Further I found out that if put_char() returns 0 in particular cases, the hvc
console starts to loop. I tried to address this problem with patch 3 and I hope
that it will work for all backends.

Finally, I would like to add a function that allows to resize the terminal
window of a HVC terminal (patch 4).


Here is an overview about the complete patch series:
 Patch 1 adds a hangup notifier
 Patch 2 adds tty driver flag TTY_DRIVER_RESET_TERMIOS
 Patch 3 fixes a loop if put_char() returns 0
 Patch 4 adds a function to resize the tty window
 Patch 5 removes __devexit of hvc_remove() for use in __(dev)init sections


Any review feedback would be greatly appreciated.
Thank you in advance.

Regards,
Hendrik
-- 
Hendrik Brueckner
D/3303 Linux on System z Development
Tel: +49 7031 16-1073
Fax: +49 7031 16-3456
eMail: brueckner@linux.vnet.ibm.com
IBM Deutschland Research & Development GmbH, Schoenaicher Str. 220, 71032 Boeblingen

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Martin Jetter
Geschaeftsfuehrung: Erich Baier
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

