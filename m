Return-Path: <linux-kernel-owner+w=401wt.eu-S932837AbXCHHUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837AbXCHHUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 02:20:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932895AbXCHHUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 02:20:11 -0500
Received: from mail.gmx.net ([213.165.64.20]:36240 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932837AbXCHHUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 02:20:09 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+F+VRKcrSFDfsHTNP/Gomo+SYGd6h7TvOwlGagFf
	6/otSDCcgvU+QX
Subject: Re: 2.6.21-rc2-mm2
From: Mike Galbraith <efault@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070307115230.727abe3e.akpm@linux-foundation.org>
References: <20070306004408.d3f6434d.akpm@linux-foundation.org>
	 <20070307164620.536fc7ff@localhost>
	 <20070307115230.727abe3e.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 08 Mar 2007 08:20:00 +0100
Message-Id: <1173338400.6734.9.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-07 at 11:52 -0800, Andrew Morton wrote:
> On Wed, 7 Mar 2007 16:46:20 -0300 "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br> wrote:
> 
> > Em Tue, 6 Mar 2007 00:44:08 -0800
> > Andrew Morton <akpm@linux-foundation.org> escreveu:
> > 
> > | 
> > | Temporarily at
> > | 
> > |   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm2/
> > | 
> > | Will appear later at
> > | 
> > |   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc2/2.6.20-rc2-mm2/
> > 
> >  Getting this while rebooting:
> > 
> > [  166.588469] BUG: atomic counter underflow at:
> > [  166.588527]  [<c01047fa>] show_trace_log_lvl+0x1a/0x30
> > [  166.588632]  [<c0104f12>] show_trace+0x12/0x20
> > [  166.588730]  [<c0104fc6>] dump_stack+0x16/0x20
> > [  166.588828]  [<c01eaf41>] kref_put+0xa1/0x100
> > [  166.588927]  [<c01ea084>] kobject_put+0x14/0x20
> > [  166.589027]  [<c01ea222>] kobject_unregister+0x22/0x30
> > [  166.589127]  [<c025ed69>] bus_remove_driver+0x79/0x90
> > [  166.589227]  [<c025f9bb>] driver_unregister+0xb/0x20
> > [  166.589327]  [<c0205c03>] pci_unregister_driver+0x13/0x70
> > [  166.589428]  [<dc951c9d>] alsa_card_via82xx_exit+0xd/0xf [snd_via82xx]
> > [  166.589534]  [<c0140c10>] sys_delete_module+0x140/0x1b0
> > [  166.589635]  [<c01040ce>] sysenter_past_esp+0x5f/0x99
> > [  166.589734]  =======================
> > 
> 
> Me too.  Greg has reverted the offenging commit, so now rmmod of the IPMI
> driver locks the machine again.

Hi,

The hang (which /me screwed up fixing) isn't upon rmmod, it's when IPMI
is built-in and ipmi_si finds nobody home.  Driver tries to back out,
and waits forever for completion. (about 0.7 seconds into boot)

	-Mike

