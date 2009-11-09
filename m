Return-Path: <linux-kernel-owner+w=401wt.eu-S1755938AbZKINfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbZKINfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 08:35:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755919AbZKINfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 08:35:18 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:31462 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870AbZKINfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 08:35:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dyd4JHXDHZ83IqfcsB3GwGPQhxZvzmE8NNxWK3nuo9eaUeU7+InVaFfytTZrZd3AEc
         JHPDq9nhuO7pc0ZPCpEwP91jtFTx6HMhtT5PDENvsmMQ4yO1iPHXBEvec2u2bJ6v8sBP
         w/3gk2euFnnQyyaDee5EkTOEfHVSRZbAAhNjc=
Date: Mon, 9 Nov 2009 14:35:15 +0100
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 2/2] x86, amd-ucode: Remove needless log messages
Message-ID: <20091109133515.GD18592@alberich.amd.com>
References: <20091029134552.GC30802@alberich.amd.com>
 <20091029134742.GD30802@alberich.amd.com>
 <20091108145748.GB12290@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091108145748.GB12290@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 08, 2009 at 03:57:48PM +0100, Ingo Molnar wrote:
> 
> * Andreas Herrmann <herrmann.der.user@googlemail.com> wrote:

 [...]

> > -	if (mc_header->processor_rev_id != equiv_cpu_id) {
> > -		printk(KERN_ERR	"microcode: CPU%d: patch mismatch "
> > -		       "(processor_rev_id: %x, equiv_cpu_id: %x)\n",
> > -		       cpu, mc_header->processor_rev_id, equiv_cpu_id);
> > +	if (mc_header->processor_rev_id != equiv_cpu_id)
> >  		return 0;
> > -	}
> >  
> >  	/* ucode might be chipset specific -- currently we don't support this */
> >  	if (mc_header->nb_dev_id || mc_header->sb_dev_id) {
> 
> but why remove this one? Someone tries to load a mismatching microcode 
> file, isnt that some sort of bug in user-space? (Which ought to find out 
> whether it has anything for the CPU at hand, and only attempt it if it's 
> matching - or so.)

The ucode file that we provide contains many ucode patches -- its a
"container" file providing patches for several CPUs. Of course this
means that there are patches in the file which are not meant for that
CPU -- that is no error case but rather normal.

> maybe it's not a KERN_ERR but KERN_INFO, but still.

KERN_DEBUG at the most. It's simple as that: if the CPU has same
PATCH_LEVEL before and after microcode.ko tried to update the ucode,
there either was no ucode-file available or it just didn't contain a
newer ucode version for this CPU.

Andreas
