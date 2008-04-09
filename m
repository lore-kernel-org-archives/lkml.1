Return-Path: <linux-kernel-owner+w=401wt.eu-S1753475AbYDIOfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbYDIOfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 10:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754171AbYDIOfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 10:35:25 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:48943 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbYDIOfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 10:35:24 -0400
Date: Wed, 9 Apr 2008 15:35:17 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Johannes Weiner <hannes@saeurebad.de>
cc: Roel Kluin <12o3l@tiscali.nl>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dz: test after postfix decrement fails in
 dz_console_putchar()
In-Reply-To: <87ve2rqh6u.fsf@saeurebad.de>
Message-ID: <alpine.SOC.1.00.0804091524290.6438@piorun>
References: <47FC93BC.5020201@tiscali.nl> <87ve2rqh6u.fsf@saeurebad.de>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Apr 2008, Johannes Weiner wrote:

> The intention was probably that this gets executed if the break in the
> loop (trdy == dport->port.line) is reached.  Without your fix, this
> branch is also taken if the while-loop terminates with loops == -1
> because of the postfix dec.

 You are right about the intention -- you cannot send a character to the 
transmitter unless the intended line has been reported as selected for 
transmission by the serial controller.  Otherwise it will go to the wrong 
line -- this is a serial multiplexer that selects transmission lines by 
itself.

 It used to be the other kind of a "while" loop.  This is a cut & paste 
bug -- I noticed the problem with the terminating condition of the loop 
and correctly moved it to the end, but forgot to adjust the 
decrementation.

> Your fix is correct but your changelog entry is wrong.

 s/fails/incorrectly succeeds/

  Maciej
