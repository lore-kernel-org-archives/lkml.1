Return-Path: <linux-kernel-owner+w=401wt.eu-S965864AbXCPTLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965864AbXCPTLN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 15:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965874AbXCPTLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 15:11:13 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:60157 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965864AbXCPTLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 15:11:12 -0400
X-Greylist: delayed 1351 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Mar 2007 15:11:12 EDT
Date: Fri, 16 Mar 2007 15:47:35 -0300
From: John Coppens <john@jcoppens.com>
To: linux-kernel@vger.kernel.org
Subject: Conflict between ide and usb?
Message-Id: <20070316154735.6de11eca.john@jcoppens.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all.

I installed ueagle-atm, which, by itself, is working fine with an 
MT-810 modem.

The problem I have, is that when I copy a file from a DVD to harddisk,
the internet connection almost dies (it slows down terribly, so much so
that established connections actually disconnect, ping looses packets,
DNS lookup fails, etc). After copy ends, all returns to normal.

The machine is an AMD64, still in x86 mode though. CPU activity is very
low during the copy, so it's not a CPU problem. Kernel is 2.6.20.2. APIC
is enabled. No error message found in either /var/log/messages or syslog.
DVD and HD are on different IDE interfaces.

Can anyone suggest where to start looking for a solution?

Cheers,
John

$ cat interrupts
           CPU0       CPU1       
  0:   58428350    6031800    XT-PIC-XT        timer
  1:     204337          9   IO-APIC-edge      i8042
  6:          0          3   IO-APIC-edge      floppy
  7:    6031308   58426101   IO-APIC-edge      parport0
  9:          0          0   IO-APIC-fasteoi   acpi
 12:     211041    5153326   IO-APIC-edge      i8042
 14:      93535     316012   IO-APIC-edge      ide0
 15:     246534         40   IO-APIC-edge      ide1
 16:       2591    1737056   IO-APIC-fasteoi   libata, HDA Intel
 17:         41          1   IO-APIC-fasteoi   libata, ehci_hcd:usb2
 18:    7717494   19142555   IO-APIC-fasteoi   eth0
 19:          0          0   IO-APIC-fasteoi   eth1
 20:   90833792    3057782   IO-APIC-fasteoi   ohci_hcd:usb1
 21:   22135804          1   IO-APIC-fasteoi   nvidia
 22:          0          0   IO-APIC-fasteoi   saa7130[0]
NMI:          0          0 
LOC:   64460593   64460595 
ERR:          1
MIS:          0

$ lsmod
Module                  Size  Used by
pppoe                   9792  2 
pppox                   3016  1 pppoe
ppp_generic            21396  6 pppoe,pppox
slhc                    5440  1 ppp_generic
br2684                  6596  1 
i2c_viapro              7380  0 
w83627ehf              16140  0 
i2c_isa                 4096  1 w83627ehf
snd_seq_oss            26368  0 
snd_seq_midi_event      5952  1 snd_seq_oss
snd_seq                41232  4 snd_seq_oss,snd_seq_midi_event
snd_seq_device          6284  2 snd_seq_oss,snd_seq
snd_pcm_oss            34912  0 
snd_mixer_oss          13376  4 snd_pcm_oss
ipt_REJECT              3648  1 
ipt_MASQUERADE          2944  1 
ipt_LOG                 5760  1 
xt_limit                2560  1 
xt_state                2368  3 
iptable_filter          2688  1 
iptable_nat             6020  1 
nf_nat                 13740  2 ipt_MASQUERADE,iptable_nat
nf_conntrack_ipv4      11980  5 iptable_nat
nf_conntrack           44168  5
ipt_MASQUERADE,xt_state,iptable_nat,nf_nat,nf_conntrack_ipv4
ip_tables               9700  2 iptable_filter,iptable_nat
ueagle_atm             21032  0 firmware_class          7360  1 ueagle_atm
usbatm                 14464  2 ueagle_atm
atm                    33716  4 br2684,usbatm
usblp                  11136  0 
ide_scsi               13128  0 
tuner                  55272  0 
saa7134               105952  0 
snd_hda_intel          15192  3 
snd_hda_codec         149120  1 snd_hda_intel
video_buf              18500  1 saa7134
compat_ioctl32          1536  1 saa7134
ir_kbd_i2c              6928  1 saa7134
ir_common              26372  2 saa7134,ir_kbd_i2c
ehci_hcd               24332  0 
ohci_hcd               16708  0 
videodev               23488  1 saa7134
snd_pcm                61124  3 snd_pcm_oss,snd_hda_intel,snd_hda_codec
snd_timer              16836  2 snd_seq,snd_pcm
snd                    39268  9
snd_seq_oss,snd_seq,snd_seq_device,snd_pcm_oss,snd_mixer_oss,snd_hda_intel,snd_hda_codec,snd_pcm,snd_timer
snd_page_alloc          7368  2 snd_hda_intel,snd_pcm
sg                     19032  0 i2c_nforce2             4800  0 
nvidia               6817908  22 
v4l2_common            21312  3 tuner,saa7134,videodev
v4l1_compat            12036  2 saa7134,videodev
k8temp                  4544  0 
usbcore               101768  6 ueagle_atm,usbatm,usblp,ehci_hcd,ohci_hcd
ne2k_pci                8736  0 
8390                    7808  1 ne2k_pci
forcedeth              37192  0 
parport_pc             22628  0 
parport                30728  1 parport_pc
