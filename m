Return-Path: <linux-kernel-owner+w=401wt.eu-S1754568AbXFXF3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbXFXF3P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 01:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbXFXF3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 01:29:06 -0400
Received: from mtoichi16.ns.itscom.net ([219.110.2.186]:52789 "EHLO
	mtoichi16.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbXFXF3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 01:29:04 -0400
Date: Sun, 24 Jun 2007 14:27:49 +0900
From: Mattia Dongili <malattia@linux.it>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: can't suspend on vaio sz (rc4 and rc5 are ok) [was Re: 2.6.22-rc4-mm2]
Message-ID: <20070624052749.GE5108@inferi.kami.home>
References: <20070622092518.GD25100@inferi.kami.home> <Pine.LNX.4.44L0.0706220957560.3290-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0706220957560.3290-100000@iolanthe.rowland.org>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.22-rc4-mm2-1 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2007 at 09:59:47AM -0400, Alan Stern wrote:
> On Fri, 22 Jun 2007, Mattia Dongili wrote:
> 
> > > Yes, the problem is not present after reverting this patch.
> > 
> > Not for me, I had that patch already reverted. As I said there was a
> > point when bisecting which the kernel came back to life instead of just
> > hanging trying to suspend.
> > I'll try to get a trace with that. May the usb_storage verbose debug
> > help there?
> 
> I've lost track of the start of this thread, so it would help to see a
> dmesg log with CONFIG_USB_DEBUG turned on.  CONFIG_USB_STORAGE_DEBUG
> doesn't matter so much because the usb-storage suspend and resume
> routines don't do a lot of work.

Sorry, it was probably me who messed things up. It looks like it's not
usb-storage who's preventing suspend here. I have this diff between a
single user mode where I can suspend and a multiuser environment where
suspend hangs, will go loading the missing modules one by one and get a
better idea...
Sorry for the noise.

--- /root/lsmod-str.txt	2007-06-24 10:58:09.953207666 +0900
+++ /root/lsmod-str-nono.txt	2007-06-24 14:21:33.354417422 +0900
@@ -1,10 +1,20 @@
+ac
+acpi_cpufreq
 agpgart
 arc4
+auth_rpcgss
 backlight
+battery
 blkcipher
 bluetooth
+button
 cdrom
 cfg80211
+cpufreq_conservative
+cpufreq_ondemand
+cpufreq_powersave
+cpufreq_stats
+cpufreq_userspace
 dm_crypt
 dm_mirror
 dm_mod
@@ -12,20 +22,39 @@
 ecb
 ehci_hcd
 evdev
+exportfs
+fan
 firmware_class
+freq_table
 fuse
 hci_usb
 i2c_i801
 ide_cd
+inet_diag
 intel_agp
+iptable_filter
+iptable_nat
+ip_tables
+ipt_MASQUERADE
+ipv6
 iwl3945
+l2cap
+lockd
 loop
 mac80211
+nf_conntrack
+nf_conntrack_ipv4
+nf_nat
+nfnetlink
+nfs
+nfs_acl
+nfsd
 pcmcia
 pcmcia_core
 psmouse
 r5u870
 rc80211_simple
+rfcomm
 rsrc_nonstatic
 rtc
 sky2
@@ -38,16 +67,22 @@
 snd_timer
 sony_laptop
 soundcore
+sunrpc
+tcp_diag
+thermal
 tifm_7xx1
 tifm_core
 tpm
 tpm_bios
 tpm_infineon
 uhci_hcd
-usb_storage
 usbcore
+usb_storage
 v4l1_compat
 v4l2_common
 video_buf
 videodev
+x_tables
+xt_state
+xt_tcpudp
 yenta_socket

-- 
mattia
:wq!
