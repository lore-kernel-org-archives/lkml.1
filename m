Return-Path: <linux-kernel-owner+w=401wt.eu-S1755104AbYK1WCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbYK1WCP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 17:02:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbYK1WB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 17:01:56 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:26127 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbYK1WBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 17:01:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PLDjOdS5c/k0Z+BZE/HJQf9HRMn4TrY1ISdYSiRg9n+98pK17seAtx1t1jH4YPLQvn
         B0hej77hQp3mohVaqUu6Y13Muj/5SiOLQHKAm0bH/uxDc40gQwDnISYMxxll5NIgzTuM
         MrrDnyIPAPGsR94WydJkRYPLUoON8g4TIvyNQ=
Date: Fri, 28 Nov 2008 23:01:43 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: option: oops on unload (2.6.27.4)
Message-ID: <20081128220142.GC6750@joi>
References: <20081128213254.GB6750@joi> <20081128215021.GA25391@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081128215021.GA25391@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2008 at 01:50:21PM -0800, Greg KH wrote:
> On Fri, Nov 28, 2008 at 10:32:59PM +0100, Marcin Slusarz wrote:
> > It's not new bug - I've seen this oops many times but on much older
> > kernels (2.6.18, probably on 2.6.24 too).
> > 
> > I tried to rmmod it (and all usb modules) because sometimes it helps when
> > modem disconnects and can't connect again.
> > 
> > [25350.138850] BUG: unable to handle kernel paging request at e0857fb4
> > [25350.138866] IP: [<e0a22e80>] :usbcore:unlink1+0xab/0xb9
> > [25350.138921] *pde = 1f80f067 *pte = 00000000 
> > [25350.138934] Oops: 0000 [#1] PREEMPT SMP 
> > [25350.138945] Modules linked in: r128 drm ipt_REDIRECT ipt_MASQUERADE xt_tcpudp xt_multiport iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack iptable_filter ip_tables ppp_deflate zlib_deflate zlib_inflate bsd_comp ppp_async crc_ccitt ppp_generic slhc ipt_REJECT x_tables loop option usbserial snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer snd 8139cp i2c_i801 floppy 8139too 3c59x psmouse intel_agp soundcore snd_page_alloc sg mii usbcore agpgart i2c_core sr_mod evdev dcdbas cdrom [last unloaded: uhci_hcd]
> > [25350.139052] 
> > [25350.139059] Pid: 2807, comm: pppd Not tainted (2.6.27.4 #5)
> > [25350.139065] EIP: 0060:[<e0a22e80>] EFLAGS: 00010286 CPU: 0
> > [25350.139088] EIP is at unlink1+0xab/0xb9 [usbcore]
> 
> Yes, I've seen this before, what module are you unloading, uhci-hcd or
> the option module?

I don't know :| I invoked "rmmod option usbserial uhci_hcd usbcore"
 
> Can you try 2.6.28-rc6? 

Yes. I'll check it in few days.

> I think we have fixed a few things in this area
> that should resolve this, if it is the uhci-hcd driver you are
> unloading.

Marcin
