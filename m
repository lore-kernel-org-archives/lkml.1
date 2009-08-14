Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbZHNKDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbZHNKDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 06:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbZHNKDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 06:03:51 -0400
Received: from www.lumino.de ([85.159.12.10]:49203 "HELO imap.lumino.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754024AbZHNKDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 06:03:50 -0400
Message-ID: <4A85367B.5080603@lumino.de>
Date: Fri, 14 Aug 2009 12:03:39 +0200
From: Michael Schnell <mschnell@lumino.de>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
CC: Mike Frysinger <vapier.adi@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       Thomas Chou <thomas@wytron.com.tw>
Subject: Re: implementing Futex
References: <4A842B32.5030401@lumino.de> <200908131839.41803.arnd@arndb.de> <4A8525A1.205@lumino.de> <200908141128.01179.arnd@arndb.de>
In-Reply-To: <200908141128.01179.arnd@arndb.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:

> It sounds like this would be an optional feature of the FPGA code,
> and therefore I'd still suggest implementing option A with a compile-time
> choice so you don't need to have it. 

Yep that is the plan.

If the custom instruction is not provided either the "common area" trick
is used or (worse of course) the pthread_mutex calls fall back to use an
OS based mutex instead of a FUTEX.


>>  If so
>>  in that code sequence we are in "System Mode".
> 
> Yes.


Great !

Thus supposedly, as of Kernel 2.6.31, We don't need modifications in the
Kernel at all for NIOS supporting FUTEX. Only the user land library
needs to be tweaked.

OK, if we decide to use the "Common Area for atomic functions" trick, we
do need to create same in the Kernel startup code and enhance interrupt
return code appropriately. But I suppose we can borrow most of this from
the  Blackfin or sh implementation.

-Michael

