Return-Path: <linux-kernel-owner+w=401wt.eu-S1757269AbZCJQM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269AbZCJQM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755177AbZCJQMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:12:08 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:50870 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589AbZCJQMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:12:07 -0400
Message-ID: <49B6912F.4040506@freescale.com>
Date: Tue, 10 Mar 2009 11:11:27 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Will Newton <will.newton@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       rdreier@cisco.com, jirislaby@gmail.com, peterz@infradead.org,
       hancockrwd@gmail.com, jeremy@goop.org
Subject: Re: [PATCH v4] introduce macro spin_event_timeout()
References: <1236699004-1863-1-git-send-email-timur@freescale.com>	 <20090310153537.5fd5d84d@lxorguk.ukuu.org.uk>	 <49B68C37.8010803@freescale.com> <87a5b0800903100905l71f15141n7a273df21bfa77e2@mail.gmail.com>
In-Reply-To: <87a5b0800903100905l71f15141n7a273df21bfa77e2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will Newton wrote:

> The correct timescale is rather application dependant - for some
> accesses that cross clock domains it can be a requirement to wait for
> a small number of core clock cycles (2 - 20) for a condition to become
> true, for others, e.g. PIO, it is more appropriate to wait for a few
> 100 cycles.

The timeout is only needed to avoid hangs in the driver.  If the
response normally comes within 20 clocks, but you waited two
milliseconds until you gave up, that's not a bad thing.  At least after
two milliseconds you've aborted the loop and returned an error.

-- 
Timur Tabi
Linux kernel developer at Freescale
