Return-Path: <linux-kernel-owner+w=401wt.eu-S1752713AbZLaQl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbZLaQl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 11:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbZLaQl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 11:41:27 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:35885 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbZLaQl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 11:41:27 -0500
Date: Thu, 31 Dec 2009 11:40:42 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: backwards busy wait using "time_before()"??
Message-ID: <alpine.LFD.2.00.0912311136560.3596@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  if this is an idiotic question, i'll blame it on the fact that
there's only decaf left in the house.

  from drivers/spi/spi_stmp.c:

   #define busy_wait(cond)                                              \
        ({                                                              \
        unsigned long end_jiffies = jiffies + STMP_SPI_TIMEOUT;         \
        bool succeeded = false;                                         \
        do {                                                            \
                if (cond) {                                             \
                        succeeded = true;                               \
                        break;                                          \
                }                                                       \
                cpu_relax();                                            \
        } while (time_before(end_jiffies, jiffies));                    \
        succeeded;                                                      \
        })


  is it just me, or do those arguments to time_before() look
backwards?

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
