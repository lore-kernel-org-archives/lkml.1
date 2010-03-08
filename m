Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab0CHLkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 06:40:07 -0500
Received: from cantor.suse.de ([195.135.220.2]:48885 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754341Ab0CHLkF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 06:40:05 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH] x86 apic: Ack all pending irqs when crashed/on kexec
Date: Mon, 8 Mar 2010 12:40:03 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.1-desktop; KDE/4.3.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
       Kerstin Jonsson <kerstin.jonsson@ericsson.com>, jbohac@novell.com,
       Yinghai Lu <yinghai@kernel.org>, akpm@linux-foundation.org,
       mingo@elte.hu, Avi Kivity <avi@redhat.com>
References: <1268047030-29911-1-git-send-email-trenn@suse.de> <20100308113452.GK6004@lenovo>
In-Reply-To: <20100308113452.GK6004@lenovo>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003081240.03265.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 March 2010 12:34:52 Cyrill Gorcunov wrote:
> On Mon, Mar 08, 2010 at 12:17:10PM +0100, Thomas Renninger wrote:
> ...
> > diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> > index 3987e44..93cdb2a 100644
> > +	if (cpu_has_tsc)
> > +		rdtscll(ntsc);
> 
> Perhaps rdtscll(tsc)?
Oh dear..., I played with this to wipe out:
warning: ‘tsc’ may be used uninitialized in this function

> > +	    if (cpu_has_tsc) {
> > +		    rdtscll(ntsc);
> > +		    max_loops = (cpu_khz << 10) - (ntsc - tsc);
> 
> Where is tsc modified? It remains tsc = 0 all the time?
> Or I miss the snippet where it is set?
Yes, you are right..., next version, thanks a lot for looking at this,

    Thomas
