Return-Path: <linux-kernel-owner+w=401wt.eu-S1753766AbXLGJ7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbXLGJ7H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 04:59:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbXLGJ6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 04:58:53 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:58548 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbXLGJ6v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 04:58:51 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] IB/ehca: Serialize HCA-related hCalls on POWER5
Date: Fri, 7 Dec 2007 10:58:37 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Roland Dreier <rdreier@cisco.com>, Joachim Fenkes <fenkes@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, OF-EWG <ewg@lists.openfabrics.org>,
       Christoph Raisch <raisch@de.ibm.com>, Marcus Eder <meder@de.ibm.com>,
       OF-General <general@lists.openfabrics.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200712061607.20004.fenkes@de.ibm.com> <200712061648.24806.arnd@arndb.de> <ada7ijrd6gy.fsf@cisco.com>
In-Reply-To: <ada7ijrd6gy.fsf@cisco.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712071058.38416.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18zno4gW4PYlDFl8G1tpJQdWZxbsUSoG+6Go4E
 SuDuvuhgON6K27DCtlPmnDt9tGn9yLMkFUuYQuIQWsPU5CFWtZ
 WPPN8DRFpxZV2mCJugBgw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 December 2007, Roland Dreier wrote:
>  > Regarding the performance problem, have you checked whether converting all
>  > your spin_lock_irqsave to spin_lock/spin_lock_irq improves your performance
>  > on the older machines? Maybe it's already fast enough that way.
> 
> It does seem that the only places that the hcall_lock is taken also
> use msleep, so they must always be in process context.  So you can
> safely just use spin_lock(), right?

I think it needs some more inspection. The msleep in there is only called
for hcalls that return H_IS_LONG_BUSY(). In theory, you can call
ehca_plpar_hcall_norets() from inside an interrupt handler if the
hcall in question never returns long busy.

	Arnd <><
