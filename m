Return-Path: <linux-kernel-owner+w=401wt.eu-S1756168AbZDAKYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbZDAKYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 06:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753791AbZDAKX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 06:23:58 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:55958 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbZDAKX4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 06:23:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=GNfZmKXMtAxgVEVe+HB/r5TAk+WFf6mN1CmDzlsWgrh+MI5I/ZfNmiahdT8W1ijwJi
         kyaAjCKhImdAsWC3PG/PPOmUsDsicS8GVzlfCQWg6TZWCWlLiPW6+YZK+Sye2hPzzqij
         cEQnUY0+kgWc0aGDHncwYyq5YXZ0zMi9OpW84=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: 2.6.29 git master and PAT problems
Date: Wed, 1 Apr 2009 12:23:49 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29; KDE/4.2.2; x86_64; ; )
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200903302317.04515.a.miskiewicz@gmail.com> <200903310944.32883.a.miskiewicz@gmail.com> <20090331232109.GA11980@linux-os.sc.intel.com>
In-Reply-To: <20090331232109.GA11980@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904011223.50050.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 of April 2009, Pallipadi, Venkatesh wrote:
> On Tue, Mar 31, 2009 at 12:44:32AM -0700, Arkadiusz Miskiewicz wrote:
> > On Tuesday 31 of March 2009, Pallipadi, Venkatesh wrote:
> > > On Mon, Mar 30, 2009 at 04:25:11PM -0700, Arkadiusz Miskiewicz wrote:
> > > > On Tuesday 31 of March 2009, Arkadiusz Miskiewicz wrote:
> > > > > On Monday 30 of March 2009, Pallipadi, Venkatesh wrote:
> > > > >
> > > > > More info follows. Now I've switched to
> > > > > e1c502482853f84606928f5a2f2eb6da1993cda1 which contains latest drm
> > > > > fixes and now I get much lower numbers of PAT errors but still.
> > > >
> > > > Also when I switch t400 into discrete mode (radeon hd 3400 instead
> > > > of integrated intel GM45) I get such errors (probably unrelated
> > > > to these seen when using intel):
> > > >
> > > > [  419.187657] X:10550 conflicting memory types cfff0000-d0000000
> > > > uncached<->uncached-minus [  419.187670] reserve_memtype failed
> > > > 0xcfff0000-0xd0000000, track uncached, req write-back [  419.553914]
> > > > X:10550 conflicting memory types cfff0000-d0000000
> > > > uncached<->uncached-minus [  419.553923] reserve_memtype failed
> > > > 0xcfff0000-0xd0000000, track uncached, req write-back [  419.813592]
> > > > X:10550 conflicting memory types cfff0000-d0000000
> > > > uncached<->uncached-minus [  419.813601] reserve_memtype failed
> > > > 0xcfff0000-0xd0000000, track uncached, req write-back [  420.100102]
> > > > X:10550 conflicting memory types cfff0000-d0000000
> > > > uncached<->uncached-minus [  420.100111] reserve_memtype failed
> > > > 0xcfff0000-0xd0000000, track uncached, req write-back
> > >
> > > Yes. This is a different problem than the freeing invalid type one. Are
> > > these errors also with latest git kernel? Can you try the patch below
> > > (which is a part of a bigger cleanup patch I have lined up).
> >
> > It's a latest git kernel as of today morning
> > (latest commit is 15f7176eb1cccec0a332541285ee752b935c1c85)
> > + your patch. Problem persists:
> >
> > [   74.696353] [drm] Setting GART location based on new memory map
> > [   74.711520] [drm] Loading RV620 CP Microcode
> > [   74.711792] [drm] Loading RV620 PFP Microcode
> > [   74.726719] [drm] Resetting GPU
> > [   74.726776] [drm] writeback test succeeded in 1 usecs
> > [   75.256034] X:5366 conflicting memory types d0000000-e0000000
> > uncached-minus<->write-combining [   75.256043] reserve_memtype failed
> > 0xd0000000-0xe0000000, track uncached-minus, req write-back [  
> > 75.849951] X:5366 conflicting memory types d0000000-e0000000
> > uncached-minus<->write-combining [   75.849960] reserve_memtype failed
> > 0xd0000000-0xe0000000, track uncached-minus, req write-back [  
> > 76.054374] X:5366 conflicting memory types d0000000-e0000000
> > uncached-minus<->write-combining [   76.054377] reserve_memtype failed
> > 0xd0000000-0xe0000000, track uncached-minus, req write-back [  
> > 76.074481] X:5378 freeing invalid memtype d0000000-e0000000
> > [   76.176881] X:5366 conflicting memory types d0000000-e0000000
> > uncached-minus<->write-combining [   76.176885] reserve_memtype failed
> > 0xd0000000-0xe0000000, track uncached-minus, req write-back [  
> > 76.207734] X:5380 freeing invalid memtype d0000000-e0000000
>
> OK. We now have a theory on what is going wrong here.
>
> The problem seems to be pci mmap uses vm_page_prot flag to remember the
> memtype for this region. Looks like that memtype is somehow getting cleared
> in this case. We still don't know where it is getting cleared. But, with
> debug patch below we can be sure that it is indeed getting cleared, which
> is causing problems on fork() as child wont know the memtype that parent
> got.
>
> Can you please try the below debug patch over upstream git and check
> whether you indeed hit the warnon.

warns triggered:

[   73.912492] tun: Universal TUN/TAP device driver, 1.6                                                                                         
[   73.912499] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>                                                                            
[   74.257914] ip_tables: (C) 2000-2006 Netfilter Core Team                                                                                      
[   74.344329] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)                                                                             
[   74.344803] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use                                                              
[   74.344809] nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or                                                        
[   74.344814] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.                                                                            
[   83.662071] pci 0000:01:00.0: power state changed by ACPI to D0                                                                               
[   83.662080] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16                                                                      
[   83.670568]   get_mtrr: cpu0 reg00 base=000013c000 size=0000004000 uncachable                                                                 
[   83.670572]   get_mtrr: cpu0 reg01 base=0000000000 size=0000080000 write-back                                                                 
[   83.670575]   get_mtrr: cpu0 reg02 base=0000080000 size=0000040000 write-back                                                                 
[   83.670577]   get_mtrr: cpu0 reg03 base=0000100000 size=0000040000 write-back                                                                 
[   83.670601]   get_mtrr: cpu0 reg00 base=000013c000 size=0000004000 uncachable                                                                 
[   83.670604]   get_mtrr: cpu0 reg01 base=0000000000 size=0000080000 write-back                                                                 
[   83.670607]   get_mtrr: cpu0 reg02 base=0000080000 size=0000040000 write-back                                                                 
[   83.670609]   get_mtrr: cpu0 reg03 base=0000100000 size=0000040000 write-back                                                                 
[   83.670849]   get_mtrr: cpu0 reg00 base=000013c000 size=0000004000 uncachable                                                                 
[   83.670852]   get_mtrr: cpu0 reg01 base=0000000000 size=0000080000 write-back                                                                 
[   83.670854]   get_mtrr: cpu0 reg02 base=0000080000 size=0000040000 write-back                                                                 
[   83.670857]   get_mtrr: cpu0 reg03 base=0000100000 size=0000040000 write-back                                                                 
[   83.672523] ------------[ cut here ]------------                                                                                              
[   83.672525] WARNING: at arch/x86/pci/i386.c:273 pci_track_mmap_page_range+0x55/0x96()                                                         
[   83.672527] Hardware name: 2764CTO                                                                                                            
[   83.672528] Modules linked in: xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables tun bridge stp rfcomm llc bnep sco hidp l2cap bluetooth ipv6 
sch_sfq i915 drm i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect fbcon tileblit font bitblit softcursor fb acpi_cpufreq cryptd aes_x86_64 aes_generic xts gf128mul dm_crypt dm_mod usbhid hid 
joydev uvcvideo videodev v4l1_compat v4l2_compat_ioctl32 snd_hda_codec_conexant arc4 ecb snd_hda_intel iwlagn thinkpad_acpi wmi snd_hda_codec iwlcore yenta_socket rsrc_nonstatic 
pcmcia_core thermal sg uhci_hcd psmouse video rfkill sdhci_pci sr_mod sdhci serio_raw firewire_ohci backlight mmc_core cdrom ehci_hcd nvram snd_hwdep output led_class snd_pcm 
firewire_core snd_timer i2c_i801 ricoh_mmc processor snd mac80211 iTCO_wdt usbcore e1000e soundcore pcspkr intel_agp i2c_core snd_page_alloc iTCO_vendor_support cfg80211 evdev ac 
battery button crc_itu_t xfs exportfs scsi_wait_scan sd_mod crc_t10dif ahci libata scsi_mod                                                                                             
[   83.672596] Pid: 5206, comm: X Not tainted 2.6.29 #155                                                                                                    
[   83.672597] Call Trace:                                                                                                                                   
[   83.672602]  [<ffffffff8024601b>] warn_slowpath+0xe5/0x138                                                                                                
[   83.672606]  [<ffffffff8022b3ef>] ? ioremap_change_attr+0x2b/0x4f                                                                                         
[   83.672608]  [<ffffffff8022e0be>] ? kernel_map_sync_memtype+0x89/0x123                                                                                    
[   83.672611]  [<ffffffff8022e7a5>] ? reserve_pfn_range+0x15f/0x1ab                                                                                         
[   83.672613]  [<ffffffff8022e985>] ? track_pfn_vma_copy+0xbc/0x176                                                                                         
[   83.672616]  [<ffffffff802b63ad>] ? copy_page_range+0x64e/0x760                                                                                           
[   83.672619]  [<ffffffff80419f74>] pci_track_mmap_page_range+0x55/0x96                                                                                     
[   83.672622]  [<ffffffff80332b2e>] bin_vma_open+0x5d/0x84                                                                                                  
[   83.672624]  [<ffffffff80244021>] dup_mm+0x2b6/0x394                                                                                                      
[   83.672626]  [<ffffffff80244bc8>] copy_process+0xa6f/0x1232                                                                                               
[   83.672629]  [<ffffffff802454e8>] do_fork+0x15d/0x36e                                                                                                     
[   83.672632]  [<ffffffff80378bc7>] ? __down_read_trylock+0x52/0x6f                                                                                         
[   83.672635]  [<ffffffff80262cc8>] ? up_read+0x1c/0x32                                                                                                     
[   83.672638]  [<ffffffff8020a6a2>] sys_clone+0x37/0x52                                                                                                     
[   83.672643]  [<ffffffff8020c213>] stub_clone+0x13/0x20                                                                                                    
[   83.672645]  [<ffffffff8020beab>] ? system_call_fastpath+0x16/0x1b                                                                                        
[   83.672647] ---[ end trace e46242fdecd88d91 ]---                                                                                                          
[   83.692900] pci 0000:01:00.0: setting latency timer to 64                                                                                                 
[   83.693199] [drm] Initialized radeon 1.29.0 20080528 for 0000:01:00.0 on minor 0                                                                          
[   83.693402]   get_mtrr: cpu0 reg00 base=000013c000 size=0000004000 uncachable                                                                             
[   83.693405]   get_mtrr: cpu0 reg01 base=0000000000 size=0000080000 write-back                                                                             
[   83.693407]   get_mtrr: cpu0 reg02 base=0000080000 size=0000040000 write-back                                                                             
[   83.693409]   get_mtrr: cpu0 reg03 base=0000100000 size=0000040000 write-back                                                                             
[   83.693411]   get_mtrr: cpu0 reg00 base=000013c000 size=0000004000 uncachable                                                                             
[   83.693413]   get_mtrr: cpu0 reg01 base=0000000000 size=0000080000 write-back                                                                             
[   83.693415]   get_mtrr: cpu0 reg02 base=0000080000 size=0000040000 write-back                                                                             
[   83.693417]   get_mtrr: cpu0 reg03 base=0000100000 size=0000040000 write-back                                                                             
[   83.694972]   get_mtrr: cpu0 reg04 base=00000d0000 size=0000010000 write-combining                                                                        
[   83.873138]   get_mtrr: cpu0 reg00 base=000013c000 size=0000004000 uncachable                                                                             
[   83.873144]   get_mtrr: cpu0 reg01 base=0000000000 size=0000080000 write-back                                                                             
[   83.873149]   get_mtrr: cpu0 reg02 base=0000080000 size=0000040000 write-back                                                                             
[   83.873153]   get_mtrr: cpu0 reg03 base=0000100000 size=0000040000 write-back                                                                             
[   83.908880]   get_mtrr: cpu0 reg00 base=000013c000 size=0000004000 uncachable                                                                             
[   83.908886]   get_mtrr: cpu0 reg01 base=0000000000 size=0000080000 write-back                                                                             
[   83.908890]   get_mtrr: cpu0 reg02 base=0000080000 size=0000040000 write-back                                                                             
[   83.908895]   get_mtrr: cpu0 reg03 base=0000100000 size=0000040000 write-back                                                                             
[   84.584974]   get_mtrr: cpu0 reg00 base=000013c000 size=0000004000 uncachable                                                                             
[   84.584983]   get_mtrr: cpu0 reg01 base=0000000000 size=0000080000 write-back                                                                             
[   84.584990]   get_mtrr: cpu0 reg02 base=0000080000 size=0000040000 write-back
[   84.584997]   get_mtrr: cpu0 reg03 base=0000100000 size=0000040000 write-back
[   84.585004]   get_mtrr: cpu0 reg00 base=000013c000 size=0000004000 uncachable
[   84.585011]   get_mtrr: cpu0 reg01 base=0000000000 size=0000080000 write-back
[   84.585017]   get_mtrr: cpu0 reg02 base=0000080000 size=0000040000 write-back
[   84.585023]   get_mtrr: cpu0 reg03 base=0000100000 size=0000040000 write-back
[   84.590095]   get_mtrr: cpu0 reg04 base=00000d0000 size=0000010000 write-combining
[   84.594770]   get_mtrr: cpu0 reg00 base=000013c000 size=0000004000 uncachable
[   84.594779]   get_mtrr: cpu0 reg01 base=0000000000 size=0000080000 write-back
[   84.594785]   get_mtrr: cpu0 reg02 base=0000080000 size=0000040000 write-back
[   84.594791]   get_mtrr: cpu0 reg03 base=0000100000 size=0000040000 write-back
[   84.594799]   get_mtrr: cpu0 reg00 base=000013c000 size=0000004000 uncachable
[   84.594805]   get_mtrr: cpu0 reg01 base=0000000000 size=0000080000 write-back
[   84.594811]   get_mtrr: cpu0 reg02 base=0000080000 size=0000040000 write-back
[   84.594818]   get_mtrr: cpu0 reg03 base=0000100000 size=0000040000 write-back
[   84.599841]   get_mtrr: cpu0 reg04 base=00000d0000 size=0000010000 write-combining
[   84.604486]   get_mtrr: cpu0 reg00 base=000013c000 size=0000004000 uncachable
[   84.604495]   get_mtrr: cpu0 reg01 base=0000000000 size=0000080000 write-back
[   84.604501]   get_mtrr: cpu0 reg02 base=0000080000 size=0000040000 write-back
[   84.604508]   get_mtrr: cpu0 reg03 base=0000100000 size=0000040000 write-back
[   84.604515]   get_mtrr: cpu0 reg00 base=000013c000 size=0000004000 uncachable
[   84.604521]   get_mtrr: cpu0 reg01 base=0000000000 size=0000080000 write-back
[   84.604528]   get_mtrr: cpu0 reg02 base=0000080000 size=0000040000 write-back
[   84.604534]   get_mtrr: cpu0 reg03 base=0000100000 size=0000040000 write-back
[   84.708155] [drm] Setting GART location based on new memory map
[   84.723310] [drm] Loading RV620 CP Microcode
[   84.723575] [drm] Loading RV620 PFP Microcode
[   84.738512] [drm] Resetting GPU
[   84.738569] [drm] writeback test succeeded in 1 usecs
[   85.293740] X:5206 conflicting memory types d0000000-e0000000 uncached-minus<->write-combining
[   85.293749] reserve_memtype failed 0xd0000000-0xe0000000, track uncached-minus, req write-back
[   85.817683] X:5206 conflicting memory types d0000000-e0000000 uncached-minus<->write-combining
[   85.817692] reserve_memtype failed 0xd0000000-0xe0000000, track uncached-minus, req write-back
[   86.074033] X:5206 conflicting memory types d0000000-e0000000 uncached-minus<->write-combining
[   86.074042] reserve_memtype failed 0xd0000000-0xe0000000, track uncached-minus, req write-back
[   86.137415] X:5239 freeing invalid memtype d0000000-e0000000
[   86.512822] X:5206 conflicting memory types d0000000-e0000000 uncached-minus<->write-combining
[   86.512831] reserve_memtype failed 0xd0000000-0xe0000000, track uncached-minus, req write-back
[   86.575023] X:5241 freeing invalid memtype d0000000-e0000000

>
> Thanks,
> Venki
>
>
> diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
> index 640339e..1294194 100644
> --- a/arch/x86/mm/pat.c
> +++ b/arch/x86/mm/pat.c
> @@ -182,10 +182,10 @@ static unsigned long pat_x_mtrr_type(u64 start, u64
> end, unsigned long req_type) u8 mtrr_type;
>
>  		mtrr_type = mtrr_type_lookup(start, end);
> -		if (mtrr_type == MTRR_TYPE_UNCACHABLE)
> -			return _PAGE_CACHE_UC;
> -		if (mtrr_type == MTRR_TYPE_WRCOMB)
> -			return _PAGE_CACHE_WC;
> +		if (mtrr_type != MTRR_TYPE_WRBACK)
> +			return _PAGE_CACHE_UC_MINUS;
> +
> +		return _PAGE_CACHE_WB;
>  	}
>
>  	return req_type;
> diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
> index f234a37..4618b71 100644
> --- a/arch/x86/pci/i386.c
> +++ b/arch/x86/pci/i386.c
> @@ -270,6 +270,7 @@ static void pci_track_mmap_page_range(struct
> vm_area_struct *vma) unsigned long flags = pgprot_val(vma->vm_page_prot)
>  						& _PAGE_CACHE_MASK;
>
> +	WARN_ON_ONCE(!flags);
>  	reserve_memtype(addr, addr + vma->vm_end - vma->vm_start, flags, NULL);
>  }
>
> @@ -338,6 +339,7 @@ int pci_mmap_page_range(struct pci_dev *dev, struct
> vm_area_struct *vma, return -EAGAIN;
>
>  	vma->vm_ops = &pci_mmap_ops;
> +	WARN_ON_ONCE(!(pgprot_val(vma->vm_page_prot) & _PAGE_CACHE_MASK));
>
>  	return 0;
>  }


-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/

