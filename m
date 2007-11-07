Return-Path: <linux-kernel-owner+w=401wt.eu-S1757849AbXKGISc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849AbXKGISc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 03:18:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756491AbXKGISY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 03:18:24 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47441 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756441AbXKGISY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 03:18:24 -0500
From: Akio Takebe <takebe_akio@jp.fujitsu.com>
To: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org
Cc: jeremy@goop.org, hollisb@us.ibm.com, kvm-devel@lists.sourceforge.net,
       avi@qumranet.com
Subject: Re: [kvm-devel] include files for kvmclock
Date: Wed, 07 Nov 2007 17:16:37 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Mailer: HidemaruMail 4.60 (WinNT,501)
In-Reply-To: <11943875433821-git-send-email-gcosta@redhat.com>
References: <11943875362987-git-send-email-gcosta@redhat.com> <11943875433821-git-send-email-gcosta@redhat.com>
Message-Id: <1DC8211684B62Btakebe_akio@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Glauber

This is interesting facility. :-)

>+#define KVM_HCALL_REGISTER_CLOCK	1
>+
>+union kvm_hv_clock {
>+	struct {
>+		u64 tsc_mult;
>+		u64 now_ns;
>+		/* That's the wall clock, not the water closet */
>+		u64 wc_sec;
>+		u64 wc_nsec;
>+		u64 last_tsc;
>+		/* At first, we could use the tsc value as a marker, but Jeremy
>+		 * well noted that it will cause us locking problems in 32-bit
>+		 * sys, so we have a special version field */
>+		u32 version;
>+	};
>+	char page_align[PAGE_SIZE];
>+};
>+
Why does kvm_hv_clock need page_align?
And also the kvm_hv_clock is alloced with kvm_vcpu,
so the align is not enough, isn't it?
I thik __atribute__((__aligne__(PAGE_SIZE)))) is better than it.

Best Regards,

Akio Takebe

