Return-Path: <linux-kernel-owner+w=401wt.eu-S1753889AbYGLIWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbYGLIWY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 04:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbYGLIWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 04:22:12 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:59868 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbYGLIWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 04:22:10 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Suresh Siddha" <suresh.b.siddha@intel.com>, "Ingo Molnar" <mingo@elte.hu>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "steiner@sgi.com" <steiner@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jeremy@goop.org" <jeremy@goop.org>
References: <20080710181634.764954000@linux-os.sc.intel.com>
	<20080711203151.GU1678@linux-os.sc.intel.com>
	<86802c440807111342j5fbf21e1ibd5129718cde4e43@mail.gmail.com>
	<20080711204521.GA15689@elte.hu>
	<20080711212418.GV1678@linux-os.sc.intel.com>
	<86802c440807111502n9835b5fybd99ed388bb71b7d@mail.gmail.com>
	<86802c440807112016k38c8161aq143463ee57b24c35@mail.gmail.com>
	<m163rb4v3j.fsf@frodo.ebiederm.org>
	<86802c440807112317h23118e29j51113a052720d8db@mail.gmail.com>
	<m1y7471t5t.fsf@frodo.ebiederm.org>
	<86802c440807120049t2aaec131l4c735712f2befb2@mail.gmail.com>
Date: Sat, 12 Jul 2008 01:11:49 -0700
In-Reply-To: <86802c440807120049t2aaec131l4c735712f2befb2@mail.gmail.com>
	(Yinghai Lu's message of "Sat, 12 Jul 2008 00:49:53 -0700")
Message-ID: <m1tzev1pyy.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Yinghai Lu" <yhlu.kernel@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0030]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [patch 00/26] x64, x2apic/intr-remap: Interrupt-remapping and x2apic support
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

>>> also read the x2APIC spec pdf, it doesn't say anything about interrupt
>>> remapping...need to be used with x2apic...
>>
>> Clustered logical mode won't work as it requires > 16 bits of apicid.
>> So only flat physical mode will work.
>
> current read_apic_id in genx2apic_cluster and genx2apic_phys is the same...

There is a fixed defined mapping between logical & physical mappings,
so that may not be an issue.

A logical cluster apicid is encoded with the high 16bits being the
cluster number, and the low 16bits being a bitmap of which core
in the cluster to send the irq to.  It sounded like a single
cluster can not span multiple sockets.

So in practice if you have 2 sockets you have a cluster id of 1.
Which means physical apic ids over 16 and logical apicids over 65536.

Eric
