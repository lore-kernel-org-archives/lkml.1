Return-Path: <linux-kernel-owner+w=401wt.eu-S1762492AbZE1NI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762492AbZE1NI4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 09:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758341AbZE1NIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 09:08:49 -0400
Received: from mail.edgeware.tv ([82.99.7.138]:45625 "EHLO mail.edgeware.tv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757068AbZE1NIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 09:08:49 -0400
X-Greylist: delayed 582 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 May 2009 09:08:49 EDT
From: "Fredrik Arnerup" <fredrik.arnerup@edgeware.tv>
To: <linux-kernel@vger.kernel.org>
Subject: IFF_LOWER_UP does not fit in ifr_flags
Date: Thu, 28 May 2009 14:59:05 +0200
Organization: Edgeware
Message-ID: <89A39FC0957640879F8975880836CF91@edgeware.tv>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AcnflBSwIOlpowRbS/qlDCmcZZ9TWg==
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation/networking/operstates.txt (and netdevice(7)) claims that
the flags IFF_LOWER_UP, IFF_DORMANT and IFF_ECHO can be read from user space
using ioctl() with SIOCGIFFLAGS. Looking in include/linux/if.h however,
the flags are returned in a struct ifreq in the field ifr_flags which
is declared as a short, while the flags are defined as:

#define IFF_LOWER_UP    0x10000         /* driver signals L1 up         */
#define IFF_DORMANT     0x20000         /* driver signals dormant       */
#define IFF_ECHO        0x40000         /* echo sent packets            */

Those aren't shorts, are they? In net/core/dev.c dev_get_flags() returns
an unsigned which is assigned to ifr_flags directly.

Looked at linux/kernel/git/stable/linux-2.6.29.y.git.
CC me please.

/Fredrik Arnerup
fredrik.arnerup@edgeware.tv

