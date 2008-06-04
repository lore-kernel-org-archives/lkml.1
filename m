Return-Path: <linux-kernel-owner+w=401wt.eu-S1760659AbYFDKyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760659AbYFDKyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 06:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760395AbYFDKyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 06:54:25 -0400
Received: from www.tglx.de ([62.245.132.106]:58365 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759001AbYFDKyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 06:54:24 -0400
Date: Wed, 4 Jun 2008 12:54:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiri Kosina <jkosina@suse.cz>
cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, avi@qumranet.com
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code:
 pm-suspend/17334
In-Reply-To: <Pine.LNX.4.64.0806031402450.6718@jikos.suse.cz>
Message-ID: <alpine.LFD.1.10.0806041252540.3235@apollo.tec.linutronix.de>
References: <c4e36d110806030142j379f5a63xfba7c3bbb9df602a@mail.gmail.com>  <Pine.LNX.4.64.0806031350330.1716@twin.jikos.cz> <c4e36d110806030501g46363beev7126c8312aadd12e@mail.gmail.com> <Pine.LNX.4.64.0806031402450.6718@jikos.suse.cz>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2008, Jiri Kosina wrote:
> > Ahh yes - you are right , I've completely forget about that old post -
> > I've thought  that my post are usually getting fixed sooner :)
> > So yes - this is actually the same bug which is still not fixed within
> > the latest kernel - the machine is running qemu guest (which seems to
> > me now somehow also slower)
> 
> OK, so it looks like KVM could be wrongly enabling IRQs/preemption on the 
> resume path. The original bug-report is on 
> http://lkml.org/lkml/2008/4/7/130

sysdev_resume() is supposed to run with interrupts disabled, at least
it was that way when the timekeeping_resume code was written.

Thanks,
	tglx
