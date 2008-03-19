Return-Path: <linux-kernel-owner+w=401wt.eu-S1761056AbYCSXIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761056AbYCSXIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:08:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937621AbYCSVdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:33:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:50683 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937618AbYCSVdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:33:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: tick-common.c hack for s390 needed
Date: Wed, 19 Mar 2008 05:12:57 +0100
User-Agent: KMail/1.9.9
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
References: <20080318093119.GA8669@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20080318093119.GA8669@osiris.boeblingen.de.ibm.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803190512.58703.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18RGhjTLKv+ZaIwbKNaC/wjvm5CEjXJRjS3vIo
 j54iT0eTQuGtjDpiQoI8ibq+D7Dd6G00DT5UjTGPSA8HRpbVY7
 Kixr3J4/Z6A1q1lVE1W3Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 March 2008, Heiko Carstens wrote:
> Actually there's a huge #ifndef CONFIG_S390 in linux/irq.h ;)
> 
> To make the code work the patch below is necessary. It's ok since all
> clock event devices on s390 are per cpu. However I think this patch is
> ugly at best. Any ideas how to fix this in a better and more generic way?

You could have an #else path in linux/irq.h to just define these
functions as s390, maybe like

static inline int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
{
	BUG();
	return 0;
}
static inline int irq_can_set_affinity(unsigned int irq)
{
	return 0;
}

	Arnd <><
