Return-Path: <linux-kernel-owner+w=401wt.eu-S1766694AbXEBWbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766694AbXEBWbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 18:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766703AbXEBWbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 18:31:11 -0400
Received: from gw.goop.org ([64.81.55.164]:60621 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766694AbXEBWbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 18:31:07 -0400
Message-ID: <46391127.3000608@goop.org>
Date: Wed, 02 May 2007 15:31:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, David Chinner <dgc@sgi.com>,
       Zan Lynx <zlynx@acm.org>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [4/6] go BUG on vmallocspace in __pa()
References: <20070428191927.GN3468@stusta.de> <1177795118.7828.6.camel@localhost> <20070430035838.GC77450368@melbourne.sgi.com> <20070430091754.24df88df@the-village.bc.nu> <p73wszuyx7h.fsf@bingen.suse.de> <20070430104806.GA14944@infradead.org> <p73slaiys9v.fsf@bingen.suse.de> <20070430173819.GC19966@holomorphy.com> <20070430174510.GG19966@holomorphy.com>
In-Reply-To: <20070430174510.GG19966@holomorphy.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
>  
> +unsigned long __kvaddr_to_paddr(unsigned long kvaddr)
> +{
> +	if (high_memory)
> +		BUG_ON(kvaddr >= VMALLOC_START);
> +	else
> +		BUG_ON(kvaddr >= (unsigned long)__va(MAXMEM));
> +	return kvaddr - PAGE_OFFSET;
> +}
>   

Needs to be exported so that modules can use __pa.  Though I suspect
most modules doing so are buggy:

WARNING: "__kvaddr_to_paddr" [sound/pci/snd-intel8x0.ko] undefined!
WARNING: "__kvaddr_to_paddr" [sound/core/snd-pcm.ko] undefined!
WARNING: "__kvaddr_to_paddr" [sound/core/snd-page-alloc.ko] undefined!
WARNING: "__kvaddr_to_paddr" [net/ieee80211/ieee80211_crypt_wep.ko] undefined!
WARNING: "__kvaddr_to_paddr" [fs/xfs/xfs.ko] undefined!
WARNING: "__kvaddr_to_paddr" [fs/nfsd/nfsd.ko] undefined!
WARNING: "__kvaddr_to_paddr" [drivers/usb/misc/usbtest.ko] undefined!
WARNING: "__kvaddr_to_paddr" [drivers/scsi/sg.ko] undefined!
WARNING: "__kvaddr_to_paddr" [drivers/parport/parport_pc.ko] undefined!
WARNING: "__kvaddr_to_paddr" [drivers/net/e1000/e1000.ko] undefined!
WARNING: "__kvaddr_to_paddr" [drivers/mmc/mmc_core.ko] undefined!
WARNING: "__kvaddr_to_paddr" [drivers/mmc/mmc_block.ko] undefined!
WARNING: "__kvaddr_to_paddr" [drivers/kvm/kvm.ko] undefined!
WARNING: "__kvaddr_to_paddr" [drivers/kvm/kvm-intel.ko] undefined!
WARNING: "__kvaddr_to_paddr" [drivers/ieee1394/sbp2.ko] undefined!
WARNING: "__kvaddr_to_paddr" [drivers/ieee1394/ohci1394.ko] undefined!
WARNING: "__kvaddr_to_paddr" [drivers/char/drm/drm.ko] undefined!


    J
