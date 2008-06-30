Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625AbYF3DDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbYF3DDE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 23:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbYF3DCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 23:02:50 -0400
Received: from gw.goop.org ([64.81.55.164]:58144 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbYF3DCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 23:02:50 -0400
Message-ID: <48684CD4.7040403@goop.org>
Date: Sun, 29 Jun 2008 20:02:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nick Piggin <npiggin@suse.de>, Mark McLoughlin <markmc@redhat.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       Eduardo Habkost <ehabkost@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Stephen Tweedie <sct@redhat.com>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [Xen-devel] Re: [PATCH 00 of 36] x86/paravirt: groundwork for
 64-bit Xen support
References: <patchbomb.1214367536@localhost> <20080625084253.GA11524@elte.hu> <20080625152212.GA3442@elte.hu> <4862A6A9.1030109@goop.org> <20080626105722.GA12640@elte.hu> <20080626105818.GA13805@elte.hu> <4863A8E6.1010807@goop.org> <20080627160333.GA27072@elte.hu> <486539A3.3030102@goop.org> <20080629084318.GA28815@elte.hu>
In-Reply-To: <20080629084318.GA28815@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> with this config:
>
>   http://redhat.com/~mingo/misc/config-Sun_Jun_29_10_29_11_CEST_2008.bad
>
> i've saved the merged 2.6.26-rc8-tip-00241-gc6c8cb2-dirty tree into 
> tip/tmp.x86.xen-64bit.Sun_Jun_29_10 and pushed it out, so you can test 
> that exact version.

Looks like the setup.c unification missed the early_ioremap init from 
the early_ioremap unification.  Unconditionally call early_ioremap_init().

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff -r 5c26177fdf8c arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c	Sun Jun 29 16:57:52 2008 -0700
+++ b/arch/x86/kernel/setup.c	Sun Jun 29 19:57:00 2008 -0700
@@ -523,11 +523,12 @@
 	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
 	pre_setup_arch_hook();
 	early_cpu_init();
-	early_ioremap_init();
 	reserve_setup_data();
 #else
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
 #endif
+
+	early_ioremap_init();
 
 	ROOT_DEV = old_decode_dev(boot_params.hdr.root_dev);
 	screen_info = boot_params.screen_info;


