Return-Path: <linux-kernel-owner+w=401wt.eu-S1758785AbZEOIEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785AbZEOIEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 04:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756471AbZEOIEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 04:04:06 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:21997 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755475AbZEOIED convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 04:04:03 -0400
Message-Id: <4A0D3E11020000780000109C@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Fri, 15 May 2009 09:04:01 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Tejun Heo" <tj@kernel.org>
Cc: <mingo@elte.hu>, <andi@firstfloor.org>, <tglx@linutronix.de>,
       <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH 4/5] x86: implement percpu_alloc kernel parameter
References: <1242361739-21186-1-git-send-email-tj@kernel.org>
 <1242361739-21186-5-git-send-email-tj@kernel.org>
In-Reply-To: <1242361739-21186-5-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Tejun Heo <tj@kernel.org> 15.05.09 06:28 >>>
>@@ -395,6 +404,16 @@ out_free_ar:
> 	return ret;
> }
> 
>+/* for explicit first chunk allocator selection */
>+static char pcpu_chosen_alloc[16] __initdata;
>+
>+static int __init percpu_alloc_setup(char *str)
>+{
>+	strncpy(pcpu_chosen_alloc, str, sizeof(pcpu_chosen_alloc) - 1);
>+	return 0;
>+}
>+early_param("percpu_alloc", percpu_alloc_setup);
>+
> static inline void setup_percpu_segment(int cpu)
> {
> #ifdef CONFIG_X86_32

Does this really need to be early_param()? setup_per_cpu_areas() runs
after setup_arch(), which is where the full command line parsing happens.

Jan

