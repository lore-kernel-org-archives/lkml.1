Return-Path: <linux-kernel-owner+w=401wt.eu-S1756001AbYKENUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbYKENUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 08:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbYKENUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 08:20:13 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:58848 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbYKENUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 08:20:11 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ira Snyder <iws@ovro.caltech.edu>
Subject: Re: [PATCH RFC v2] net: add PCINet driver
Date: Wed, 5 Nov 2008 14:19:52 +0100
User-Agent: KMail/1.9.9
Cc: linuxppc-dev@ozlabs.org, Stephen Hemminger <shemminger@vyatta.com>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jan-Bernd Themann <THEMANN@de.ibm.com>
References: <20081029202027.GH12879@ovro.caltech.edu> <200811042123.03819.arnd@arndb.de> <20081104222927.GE4641@ovro.caltech.edu>
In-Reply-To: <20081104222927.GE4641@ovro.caltech.edu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811051419.53194.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19ynv+5/kfcc9Vgrnxym7KBrbIYaHJIZktKLeM
 omO/1GPv+6HL1nUU3WRvdY0waxb8ZF1tfbksfQMe+HCjuMar4z
 a2m+ch+s7DWLaxT2YnXHw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 November 2008, Ira Snyder wrote:

> So, since interrupts are disabled while my interrupt handler is running,
> I think I should be able to use spin_lock() and spin_unlock(), correct?

yes.

> But sparse gives me the following warning:
> wqt.c:185:9: warning: context imbalance in 'wqt_interrupt': wrong count at exit
> wqt.c:185:9:    context 'lock': wanted 0, got 1
> 
> If I'm using spin_lock_irqsave() and spin_lock_irqrestore() I do not get
> the same warnings. Therefore I must have some misunderstanding :)


I've seen something like that before, I think it was a bug either in
sparse or in the powerpc platform code. Try updating both the kernel
and sparse and see if it still happens.

	Arnd <><
