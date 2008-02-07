Return-Path: <linux-kernel-owner+w=401wt.eu-S932135AbYBGRqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135AbYBGRqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 12:46:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756144AbYBGRq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 12:46:28 -0500
Received: from www.tglx.de ([62.245.132.106]:42843 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755828AbYBGRq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 12:46:27 -0500
Date: Thu, 7 Feb 2008 18:46:03 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Holvenstot <cholvenstot@comcast.net>
cc: Jiri Kosina <jkosina@suse.cz>, Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-git15 Keyboard Issue?
In-Reply-To: <1202402704.6087.12.camel@popeye>
Message-ID: <alpine.LFD.1.00.0802071838110.9204@apollo.tec.linutronix.de>
References: <1202302978.9058.13.camel@popeye>  <Pine.LNX.4.64.0802061427410.30873@twin.jikos.cz>  <1202305740.9058.22.camel@popeye>  <Pine.LNX.4.64.0802061452210.30873@twin.jikos.cz>  <1202318666.6406.13.camel@popeye>  <Pine.LNX.4.64.0802071016220.30873@twin.jikos.cz>
  <1202381094.6179.0.camel@popeye>  <Pine.LNX.4.64.0802071149260.30955@jikos.suse.cz>  <alpine.LFD.1.00.0802071324410.9204@apollo.tec.linutronix.de>  <1202396868.6087.8.camel@popeye>  <alpine.LFD.1.00.0802071629350.9204@apollo.tec.linutronix.de>
 <1202402704.6087.12.camel@popeye>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Thu, 7 Feb 2008, Chris Holvenstot wrote:
> Thomas - 
> 
> I hope that, from at least my perspective, your question is rhetorical.

Yeah. The non rhetorical one was directed to Jiri. :)

> I am fully willing to publicly admit that I don't have a clue. About
> much of anything. I will even admit that until prompted by Jiri
> yesterday I had never even heard of the nohpet directive for the boot
> line. 

No problem. At the moment I'm equally clueless :)
 
> I am willing to do whatever I can to help isolate and or resolve this
> issue, but to do so I need one of you experts to firmly grab hold of
> some portion of my anatomy and guide me in the right direction.

Can you please apply the following patch, boot w/o nohpet and provide
the dmesg output ?

Thanks,
	tglx

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 429d084..4e98241 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -375,8 +375,10 @@ int __init hpet_enable(void)
 {
 	unsigned long id;
 
-	if (!is_hpet_capable())
+	if (!is_hpet_capable()) {
+		printk(KERN_INFO "HPET not available\n");
 		return 0;
+	}
 
 	hpet_set_mapping();
 
@@ -392,6 +394,7 @@ int __init hpet_enable(void)
 	 * information and the number of channels
 	 */
 	id = hpet_readl(HPET_ID);
+	printk(KERN_INFO "HPET available. ID = %lx\n", id);
 
 #ifdef CONFIG_HPET_EMULATE_RTC
 	/*
@@ -412,6 +415,7 @@ int __init hpet_enable(void)
 	return 0;
 
 out_nohpet:
+	printk(KERN_INFO "HPET disabled\n");
 	hpet_clear_mapping();
 	boot_hpet_disable = 1;
 	return 0;
