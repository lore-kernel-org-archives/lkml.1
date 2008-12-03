Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbYLCEDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbYLCEDm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 23:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbYLCEDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 23:03:34 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:57309 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbYLCEDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 23:03:34 -0500
Date: Tue, 2 Dec 2008 20:03:03 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Subject: Question on SI_ASYNCIO
Message-ID: <20081203040303.GA4071@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

SI_ASYNCIO is defined in include/asm-generic/siginfo.h as:

	#define SI_ASYNCIO      -4              /* sent by AIO completion */

The negative value makes it a 'user-space' signal according to 

	#define SI_FROMUSER(siptr)      ((siptr)->si_code <= 0)
	#define SI_FROMKERNEL(siptr)    ((siptr)->si_code > 0)

But this signal is generated in the kernel async_completed() -
drivers/usb/core/devio.c

Am trying to understand why this is considered as a user-space signal ?

Isn't SI_ASYNCIO similar to SI_POLL or SI_MESGQ - both of which are
'kernel-signals' ?

POSIX.1 explicitly ignores async io. 

Thanks,

Sukadev

