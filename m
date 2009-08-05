Return-Path: <linux-kernel-owner+w=401wt.eu-S1753144AbZHEWvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144AbZHEWvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 18:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbZHEWvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 18:51:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:51083 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731AbZHEWvn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 18:51:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,331,1246863600"; 
   d="scan'208";a="538926391"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "'Amerigo Wang'" <amwang@redhat.com>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
CC: "Luck, Tony" <tony.luck@intel.com>,
       "'linux-ia64@vger.kernel.org'" <linux-ia64@vger.kernel.org>,
       "'Neil Horman'" <nhorman@redhat.com>,
       "'Eric W. Biederman'" <ebiederm@xmission.com>,
       "'akpm@linux-foundation.org'" <akpm@linux-foundation.org>,
       "'Ingo Molnar'" <mingo@elte.hu>,
       "'Anton Vorontsov'" <avorontsov@ru.mvista.com>
Date: Wed, 5 Aug 2009 15:51:42 -0700
Subject: RE: [Patch 2/7] x86: implement crashkernel=auto
Thread-Topic: [Patch 2/7] x86: implement crashkernel=auto
Thread-Index: AcoVv4rcnRYU46vGScaeZ9LdyLAKMQAXqxrQ
Message-ID: <A6AD88C3F2289247BE726C37303E1EB8B38E48D7@orsmsx505.amr.corp.intel.com>
References: <20090805112123.6552.73574.sendpatchset@localhost.localdomain>
 <20090805112142.6552.18373.sendpatchset@localhost.localdomain>
In-Reply-To: <20090805112142.6552.18373.sendpatchset@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>+#ifdef CONFIG_KEXEC_AUTO_RESERVE
>+	if (strncmp(ck_cmdline, "auto", 4) == 0) {
>+		unsigned long long size;
>+		char tmp[32];
>+
>+		size = arch_default_crash_size(system_ram);
>+		if (size != 0) {
>+			*crash_size = size;
>+			*crash_base = arch_default_crash_base();
>+			size = scnprintf(tmp, sizeof(tmp), "%luM@%luM",
>+					(unsigned long)(*crash_size)>>20,
>+					(unsigned long)(*crash_base)>>20);
>+			/* size can't be <= 4. */
>+			if (likely((size - 4 + strlen(cmdline))
>+					< COMMAND_LINE_SIZE - 1)) {
>+				memmove(ck_cmdline + size, ck_cmdline + 4,
>+					strlen(cmdline) - (ck_cmdline + 4 - cmdline)
>+ 1);
>+				memcpy(ck_cmdline, tmp, size);
>+			}

Here the variable "size" has two different meanings. First it used for crash size. Then its meaning is changed to buffer size in ck_cmdline. And types are different too. The type for crash size is unsigned long long. But scnprintf() return int.

Could you use two variables to represent the two meanings for less confusion?

Thanks.

-Fenghua
