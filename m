Return-Path: <linux-kernel-owner+w=401wt.eu-S1762325AbYBGUkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762325AbYBGUkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:40:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755132AbYBGUkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:40:16 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:3310 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762122AbYBGUkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:40:14 -0500
Date: Thu, 7 Feb 2008 15:37:37 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Vivek Goyal <vgoyal@redhat.com>,
       tglx@linutronix.de, mingo@redhat.com, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH], issue EOI to APIC prior to calling crash_kexec in
	die_nmi path
Message-ID: <20080207203737.GB29279@hmsreliant.think-freely.org>
References: <20080206192555.GA24910@hmsendeavour.rdu.redhat.com> <20080206220001.GA15155@elte.hu> <20080206224805.GD11886@redhat.com> <47AA3B16.7000507@zytor.com> <20080206233657.GB12393@elte.hu> <m1r6fpd2uo.fsf@ebiederm.dsl.xmission.com> <20080207121719.GA29279@hmsreliant.think-freely.org> <20080207122404.GA8195@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080207122404.GA8195@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 01:24:04PM +0100, Ingo Molnar wrote:
> 
> * Neil Horman <nhorman@tuxdriver.com> wrote:
> 
> > Ingo noted a few posts down the nmi_exit doesn't actually write to the 
> > APIC EOI register, so yeah, I agree, its bogus (and I apologize, I 
> > should have checked that more carefully).  Nevertheless, this patch 
> > consistently allowed a hangning machine to boot through an Nmi lockup.  
> > So I'm forced to wonder whats going on then that this patch helps 
> > with.  perhaps its a just a very fragile timing issue, I'll need to 
> > look more closely.
> 
> try a dummy iret, something like:
> 
>   asm volatile ("pushf; push $1f; iret; 1: \n");
> 
> to get the CPU out of its 'nested NMI' state. (totally untested)
> 
> the idea is to push down an iret frame to the kernel stack that will 
> just jump to the next instruction and gets it out of the NMI nesting. 
> Note: interrupts will/must still be disabled, despite the iret. (the 
> ordering of the pushes might be wrong, we might need more than that for 
> a valid iret, etc. etc.)
> 
> 	Ingo

Will do.  I'll report results as soon as I have them,.  Thanks!
Neil

-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
