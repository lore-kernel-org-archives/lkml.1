Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbYHMExp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbYHMExp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 00:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbYHMExf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 00:53:35 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:55577 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbYHMExe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 00:53:34 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Huang Ying <ying.huang@intel.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Vivek Goyal <vgoyal@redhat.com>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
References: <1218510861.24951.40.camel@caritas-dev.intel.com>
	<20080812204900.db63deaa.akpm@linux-foundation.org>
Date: Tue, 12 Aug 2008 21:47:22 -0700
In-Reply-To: <20080812204900.db63deaa.akpm@linux-foundation.org> (Andrew
	Morton's message of "Tue, 12 Aug 2008 20:49:00 -0700")
Message-ID: <m1ej4tikrp.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1491]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH -v3 1/7] kexec jump: clean up #ifdef and comments
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Tue, 12 Aug 2008 11:14:21 +0800 Huang Ying <ying.huang@intel.com> wrote:
>
>>  	xchg(&kexec_lock, 0);
>
> kernel/kexec.c: In function 'kernel_kexec':
> kernel/kexec.c:1501: warning: value computed is not used

A good question is why we are warned.

> Is there any reason why we cannot use the more conventional
> test_and_set_bit() etc, rather than this peculiarity?
>
> Or perhaps spin_trylock?

Totally odd.

Let me stop and take a look and see what has been changed.  The original
code used a xchg based read copy update scheme, which was extremely
compatible with a lot of goals.  The primary one being no blocking paths
in a successful kexec, and minimal dependence on library functions.

We need that minimal dependence to handle the kexec on panic case.

That doesn't rule out something like test_and_set_bit.

Eric
