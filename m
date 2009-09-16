Return-Path: <linux-kernel-owner+w=401wt.eu-S1758870AbZIPMZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758870AbZIPMZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 08:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758512AbZIPMZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 08:25:23 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:14846 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbZIPMZW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 08:25:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=s3unAyripWk3jnA8OF6fhEXL2p4hqqrrNqqaf7Rl2cUttcZkyCj2BVwQKWgot7aLvx
         RdaGN33s5YlSCLN47sy9hcfXnzTnU0T6regcLnidwZDuMRTsP5HL4rLUQ3aFpEEbFtAn
         mNKa4b25O2fsY/5nFP00I728VwQOh5GlrAKTw=
From: Volker Armin Hemmann <volkerarmin@googlemail.com>
To: Oliver Neukum <oliver@neukum.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31 ehci problem - mouse dead on scroll
Date: Wed, 16 Sep 2009 14:25:18 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31r4; KDE/4.3.1; x86_64; ; )
Cc: linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
References: <200909142015.56698.volkerarmin@googlemail.com> <200909161356.26691.volkerarmin@googlemail.com> <200909161412.05041.oliver@neukum.org>
In-Reply-To: <200909161412.05041.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <200909161425.18729.volkerarmin@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mittwoch 16 September 2009, Oliver Neukum wrote:
> Am Mittwoch, 16. September 2009 13:56:26 schrieb Volker Armin Hemmann:
> > ok, I am done. Was back earlier then expected and had  an
> > all-awake-night, so lots of time:
> 
> Thank you very much for the great testing.
> 
> > with
> > USB selective suspend/resume and wakeup on
> >
> > Root Hub Transaction Translators on
> > Improved Transaction Translator scheduling off
> >
> > mouse is fine
> >
> >
> > with
> > USB selective suspend/resume and wakeup on
> >
> > Root Hub Transaction Translators off
> > Improved Transaction Translator scheduling on
> >
> > mouse is fine
> 
> So this is an EHCI root hub problem most likely.
> This means we need to include Alan, master of ehci.
> 
> He'll need additional debugging info. Do you know how to get
> at the ehci registers through debugfs?
> Furthermore, if you have a hub can you try to attach your mouse
> through a hub?
> 
> 	Regards
> 		Oliver
> 


emm, the mouse is attached through a powered 4port usb 2.0 hub. That is the 
only way to get it working. If I attach it directly (without loading ohci) it 
does not work (well, only tried with both Transaction Translator options off), 
and if I load ohci before I connect it, it is very very jerky. So jerky in 
fact, that I considered douzends of lockups a day a better alternative.

debugfs is mounted (and usbmon too.):

 cat /sys/kernel/debug/usb/ehci/0000:00:12.2/registers
bus pci, device 0000:00:12.2
EHCI Host Controller
EHCI 1.00, hcd state 1
ownership 00000001
SMI sts/enable 0xc0080000
structural params 0x00102306
capability params 0x0000a072
status 4008 Periodic FLR
command 010019 (park)=0 ithresh=1 Periodic period=256 RUN
intrenable 37 IAA FATAL PCD ERR INT
uframe 232f
port 1 status 001000 POWER sig=se0
port 2 status 001005 POWER sig=se0 PE CONNECT
port 3 status 001000 POWER sig=se0
port 4 status 001000 POWER sig=se0
port 5 status 001000 POWER sig=se0
port 6 status 001000 POWER sig=se0
irq normal 20356 err 2 reclaim 16 (lost 0)
complete 20359 unlink 0

cat /sys/kernel/debug/usb/ehci/0000:00:13.2/registers
bus pci, device 0000:00:13.2
EHCI Host Controller
EHCI 1.00, hcd state 1
ownership 00000001
SMI sts/enable 0xc0080000
structural params 0x00102306
capability params 0x0000a072
status 0008 FLR
command 010009 (park)=0 ithresh=1 period=256 RUN
intrenable 37 IAA FATAL PCD ERR INT
uframe 3a34
port 1 status 001000 POWER sig=se0
port 2 status 001000 POWER sig=se0
port 3 status 001000 POWER sig=se0
port 4 status 001000 POWER sig=se0
port 5 status 001000 POWER sig=se0
port 6 status 001000 POWER sig=se0
irq normal 0 err 0 reclaim 0 (lost 0)
complete 0 unlink 0

this is with 'all off', translators off selective resume off.


Glück Auf,
Volker


