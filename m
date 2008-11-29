Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbYK2RBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbYK2RBp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 12:01:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbYK2RBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 12:01:34 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:31927 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbYK2RBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 12:01:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BHdtfYsOjk0unDazt2MmTuIig/d7xx2q7Znih4nik+nBQP+ULKVLhoat1Rrinro6MM
         EzhJb+5buHi6pjbYTDWDFawKz8idCauhEPIGQDB31QH0h8CX+q950YlLKHDc4KbLUmAh
         tLpdNb9GJSIT9iRx0VsEYfOh1BQuDzYlCgkTI=
Date: Sat, 29 Nov 2008 18:00:37 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: option: oops on unload (2.6.27.4)
Message-ID: <20081129170027.GA5862@joi>
References: <20081128213254.GB6750@joi> <20081128215021.GA25391@suse.de> <20081128220142.GC6750@joi> <20081128235010.GB27130@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081128235010.GB27130@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2008 at 03:50:10PM -0800, Greg KH wrote:
> On Fri, Nov 28, 2008 at 11:01:43PM +0100, Marcin Slusarz wrote:
> > On Fri, Nov 28, 2008 at 01:50:21PM -0800, Greg KH wrote:
> > > On Fri, Nov 28, 2008 at 10:32:59PM +0100, Marcin Slusarz wrote:
> > > > It's not new bug - I've seen this oops many times but on much older
> > > > kernels (2.6.18, probably on 2.6.24 too).
> > > > 
> > > > I tried to rmmod it (and all usb modules) because sometimes it helps when
> > > > modem disconnects and can't connect again.
> > > > 
> > > > [25350.138850] BUG: unable to handle kernel paging request at e0857fb4
> > > > [25350.138866] IP: [<e0a22e80>] :usbcore:unlink1+0xab/0xb9
> > > > [25350.138921] *pde = 1f80f067 *pte = 00000000 
> > > > [25350.138934] Oops: 0000 [#1] PREEMPT SMP 
> > > > [25350.138945] Modules linked in: r128 drm ipt_REDIRECT ipt_MASQUERADE xt_tcpudp xt_multiport iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack iptable_filter ip_tables ppp_deflate zlib_deflate zlib_inflate bsd_comp ppp_async crc_ccitt ppp_generic slhc ipt_REJECT x_tables loop option usbserial snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer snd 8139cp i2c_i801 floppy 8139too 3c59x psmouse intel_agp soundcore snd_page_alloc sg mii usbcore agpgart i2c_core sr_mod evdev dcdbas cdrom [last unloaded: uhci_hcd]
> > > > [25350.139052] 
> > > > [25350.139059] Pid: 2807, comm: pppd Not tainted (2.6.27.4 #5)
> > > > [25350.139065] EIP: 0060:[<e0a22e80>] EFLAGS: 00010286 CPU: 0
> > > > [25350.139088] EIP is at unlink1+0xab/0xb9 [usbcore]
> > > 
> > > Yes, I've seen this before, what module are you unloading, uhci-hcd or
> > > the option module?
> > 
> > I don't know :| I invoked "rmmod option usbserial uhci_hcd usbcore"
> 
> Try them one at a time:
> 	rmmod option
> 	rmmod uhci-hcd
> 
> that should be all you need if you really need to remove all usb
> devices.
> 
> But why do you need to do this?

> > > > I tried to rmmod it (and all usb modules) because sometimes it helps when
> > > > modem disconnects and can't connect again.
