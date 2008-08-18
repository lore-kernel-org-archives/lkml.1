Return-Path: <linux-kernel-owner+w=401wt.eu-S1755286AbYHRPxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbYHRPxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 11:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbYHRPwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 11:52:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47839 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753199AbYHRPwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 11:52:50 -0400
Date: Mon, 18 Aug 2008 11:24:40 -0400
From: Dave Jones <davej@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Fries <david@fries.net>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Fix i486 suspend to disk CR4 oops
Message-ID: <20080818152440.GA26134@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ingo Molnar <mingo@elte.hu>, David Fries <david@fries.net>,
	linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Pavel Machek <pavel@ucw.cz>, "H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>
References: <20080818040340.GB17528@spacedout.fries.net> <20080818064120.GA28941@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080818064120.GA28941@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 08:41:20AM +0200, Ingo Molnar wrote:

 > diff --git a/arch/x86/kernel/efi_32.c b/arch/x86/kernel/efi_32.c
 > index 4b63c8e..5cab48e 100644
 > --- a/arch/x86/kernel/efi_32.c
 > +++ b/arch/x86/kernel/efi_32.c
 > @@ -53,7 +53,7 @@ void efi_call_phys_prelog(void)
 >  	 * directory. If I have PAE, I just need to duplicate one entry in
 >  	 * page directory.
 >  	 */
 > -	cr4 = read_cr4();
 > +	cr4 = read_cr4_safe();
 >  
 >  	if (cr4 & X86_CR4_PAE) {
 >  		efi_bak_pg_dir_pointer[0].pgd =
 > @@ -91,7 +91,7 @@ void efi_call_phys_epilog(void)
 >  	gdt_descr.size = GDT_SIZE - 1;
 >  	load_gdt(&gdt_descr);
 >  
 > -	cr4 = read_cr4();
 > +	cr4 = read_cr4_safe();
 >  
 >  	if (cr4 & X86_CR4_PAE) {
 >  		swapper_pg_dir[pgd_index(0)].pgd =

Is this part really necessary ?

Why would a 486 be in EFI code?

	Dave

-- 
http://www.codemonkey.org.uk
