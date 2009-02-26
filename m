Return-Path: <linux-kernel-owner+w=401wt.eu-S1758399AbZBZEU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758399AbZBZEU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 23:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbZBZEUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 23:20:18 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:47803 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbZBZEUQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 23:20:16 -0500
To: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200902221837.49396.rjw@sisk.pl>
	<d6200be20902251717r531c022bl4c25fcb902201188@mail.gmail.com>
	<alpine.LFD.2.00.0902251724220.3111@localhost.localdomain>
	<d6200be20902251813o3ff4a065nb0a54321e27c512d@mail.gmail.com>
	<alpine.LFD.2.00.0902251848120.3111@localhost.localdomain>
	<20090226030050.GA3361@elte.hu>
	<d6200be20902251931lf563c2aw43d5266e9677e168@mail.gmail.com>
	<alpine.LFD.2.00.0902251935190.3111@localhost.localdomain>
	<d6200be20902251950l34d5968q4b553ce8305ebd4b@mail.gmail.com>
	<alpine.LFD.2.00.0902251956450.3111@localhost.localdomain>
	<d6200be20902252013v366ce771w8a129e9f3b75927f@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 25 Feb 2009 20:20:35 -0800
In-Reply-To: <d6200be20902252013v366ce771w8a129e9f3b75927f@mail.gmail.com>
 ("Arve =?utf-8?B?SGrDuG5uZXbDpWciJ3M=?= message of "Wed\, 25 Feb 2009
 20\:13\:27 -0800")
Message-ID: <m1y6vtkewc.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: arve@android.com, tglx@linutronix.de, jbarnes@virtuousgeek.org, lenb@kernel.org, linux-pm@lists.linux-foundation.org, jeremy@goop.org, benh@kernel.crashing.org, linux-kernel@vger.kernel.org, rjw@sisk.pl, mingo@elte.hu, torvalds@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: =?ISO-8859-1?Q?;Arve Hj=c3=b8nnev=c3=a5g <arve@android.com>?=
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during  suspend-resume
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arve Hjønnevåg <arve@android.com> writes:

> We only have one gpio input driver, but I don't think is good to loose
> any wakeup interrupts. Any driver that needs an edge triggered wakeup
> interrupt will have problems if the hardware does not regenerate the
> interrupt when the host does not respond.

We are not loosing interrupts.  The normal implementation of disable
is a software disable and sets IRQ_PENDING to ensure we don't loose
interrupts when the interrupt is disabled.

Eric
