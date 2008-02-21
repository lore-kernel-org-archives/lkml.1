Return-Path: <linux-kernel-owner+w=401wt.eu-S1761997AbYBUTj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761997AbYBUTj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 14:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754193AbYBUTjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 14:39:16 -0500
Received: from smtp01.isdsl.net ([196.26.208.190]:53264 "EHLO smtp01.isdsl.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470AbYBUTjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 14:39:13 -0500
X-netsentry.modernarch.co.za-MailScanner-Watermark: 1204227519.40053@gJqLfn8lAXDU4DDMEUeW0g
Message-ID: <47BDD342.5070506@networksentry.co.za>
Date: Thu, 21 Feb 2008 21:38:42 +0200
From: Gregory Nietsky <gregory@networksentry.co.za>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Simon Richter <sjr@debian.org>
CC: Tilman Schmidt <tilman@imap.cc>, Jeff Garzik <jeff@garzik.org>,
       kkeil@suse.de, Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, isdn4linux@listserv.isdn4linux.de,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Plans for mISDN? Was: [PATCH 00/14] [ISDN] ...
References: <098123kjff90231nv098233rnvd908u234@garzik.org>	<20080217195235.GN14588@uranus.ravnborg.org>	<20080218045209.GA15141@kroah.com> <p73zltyxy9q.fsf@bingen.suse.de>	<20080219085033.GA1775@uranus.ravnborg.org>	<47BAA072.9050601@networksentry.co.za> <47BC370F.3000705@imap.cc> <47BD5360.5070706@debian.org>
In-Reply-To: <47BD5360.5070706@debian.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-netsentry.modernarch.co.za-MailScanner-Information: Please contact Network Sentry  for more information (www.networksentry.co.za)
X-netsentry.modernarch.co.za-MailScanner: Found to be clean
X-netsentry.modernarch.co.za-MailScanner-From: gregory@networksentry.co.za
X-Scan-Signature: e6d5946823bf25d3262a883618377ebc{168}}
X-Trace: smtp01.isdsl.net 1JSHFp-0004eo-Aa fce3534acaa163477900f3da6a0cf6ff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Richter wrote:
> Hi,
> 
> Tilman Schmidt wrote:
> 
>> mISDN has two problems, which are of course interrelated:
> 
> mISDN has one problem that is even bigger than these: the kernel oopses 
> if modules aren't loaded in the right order. misdn-init works around 
> that, but if it doesn't work for some reason (and I can think of 
> multiple here), the user is left with a kernel that oopses during 
> hardware discovery and never gets to a stage where this can be 
> rectified, as almost all distributions now have hardware discovery 
> before the first opportunity to get a shell. At least these were my 
> experiences the last time I tried it on my test box.
> 
> This is the reason I've kept mISDN out of the last two Debian stable 
> releases, despite users' requests.
> 
> When a hardware driver module is loaded, it should only do basic 
> hardware initialisation; it is certainly not necessary to set up the 
> entire stack (or even decide on a protocol, which currently needs to be 
> handed in via module parameter -- before userland code is there that 
> wants to talk to the hardware, there is no reason to have the hardware 
> active).
> 
>    Simon
> -- 

hi there simon ive not bothered with isdn-init i use some modprobe magic 
to sort out the mess here it is ... edit the flags as required.i agree 
this is not ideal and most drivers should have a default ill take this 
under advisement and when there is some time ill look at setting it as 
default.this recipe plays nicely with hotplug and friends.

#
#Protocol Flags
#
#0x001 1TR6 (Not Available)
#0x002 DSS1
#0x010 NT Mode
#0x020 PTP Mode
#0x040 PCM Slave Mode
#0x080 Negative Frame Pulse
#0x100 Use Setting From Previous Driver And Add To Previous Stack
#0x200 Switch DU/DD Interface

#
#Typical Usage
#
#0x02  TE Mode
#0x12  NT Mode

#
#Layer Mask To Select Layers In D Channel Stack Layer 0 (HW) is always 
included
#
#0x1 Layer 1
#0x2 Layer 2 (Only Layers 1 and 2 are needed for NT Mode)
#0x4 Layer 3
#0x8 Layer 4

#
#Typical Usage
#
#0x0f  TE Mode
#0x03  NT Mode

#
#Debug Mask
#
#0x01 IRQ Status
#0x02 D-Channel Events
#0x04 D-Channel FIFO Data
#0x08 B-Channel Events
#0x10 B-Channel FIFO Data

#
#DSP Options
#
#0x01 ULAW (Instead Of ALAW)
#0x10 Software Bridging (Instead Of Hardware)


options avmfritz protocol=0x2,0x2,0x2,0x2,0x2,0x2,0x2,0x2
options avmfritz layermask=0xf,0xf,0xf,0xf,0xf,0xf,0xf,0xf
options avmfritz debug=0x0

options hfcpci   protocol=0x2,0x2,0x2,0x2,0x2,0x2,0x2,0x2
options hfcpci   layermask=0xf,0xf,0xf,0xf,0xf,0xf,0xf,0xf
options hfcpci   debug=0x0

options hfcmulti type=8
options hfcmulti protocol=0x2,0x2,0x2,0x2,0x2,0x2,0x2,0x2
options hfcmulti layermask=0xf,0xf,0xf,0xf,0xf,0xf,0xf,0xf
options hfcmulti debug=0x0

options w6692pci protocol=0x2,0x2,0x2,0x2,0x2,0x2,0x2,0x2
options w6692pci layermask=0xf,0xf,0xf,0xf,0xf,0xf,0xf,0xf
options w6692pci debug=0x0

options sedlfax  protocol=0x2,0x2,0x2,0x2,0x2,0x2,0x2,0x2
options sedlfax  layermask=0xf,0xf,0xf,0xf,0xf,0xf,0xf,0xf
options sedlfax  debug=0x0

options hfcsusb  protocol=0x2,0x2,0x2,0x2,0x2,0x2,0x2,0x2
options hfcsusb  layermask=0xf,0xf,0xf,0xf,0xf,0xf,0xf,0xf
options hfcsusb  poll=128
options hfcsusb  debug=0x0

options mISDN_dsp options=0x10
options mISDN_dsp debug=0x0
options mISDN_dsp poll=128

install avmfritz   /usr/sbin/mkisdnnod avmfritz
install hfcpci     /usr/sbin/mkisdnnod hfcpci
install hfcmulti   /usr/sbin/mkisdnnod hfcmulti
install w6692pci   /usr/sbin/mkisdnnod w6692pci
install sedlfax    /usr/sbin/mkisdnnod sedlfax
install hfcsusb    /usr/sbin/mkisdnnod hfcsusb

------------
/usr/sbin/mkisdnnod
------------

#!/bin/bash


if [ -e /var/run/isdnprobe.pid ];then
   CURPID=`cat /var/run/isdnprobe.pid`
   if [ "$CURPID" != "$$" ] && [ -d /proc/$CURPID ] && [ "$CURPID" ];then
     exit;
    else
     echo $$ > /var/run/isdnprobe.pid
   fi;
  else
   echo $$ > /var/run/isdnprobe.pid
fi;

if [ ! -e /dev/mISDN ];then
   /bin/mknod /dev/mISDN c 46 0;
   /sbin/modprobe mISDN_l1;
   /sbin/modprobe mISDN_l2;
   /sbin/modprobe l3udss1;
   /sbin/modprobe mISDN_isac;
   /sbin/modprobe mISDN_x25dte;
   /sbin/modprobe mISDN_dtmf;
   /sbin/modprobe mISDN_dsp;
   /sbin/modprobe mISDN_debugtool
   if [ "$1" ];then
     /sbin/modprobe -s -q --ignore-install $1;
   fi;
   rm /var/run/isdnprobe.pid
  else
   /sbin/modprobe -s -q --ignore-install $1;
fi;

--

This message has been scanned for viruses and

dangerous content by Superset Technology, and 

is believed to be clean.

http://www.superset.co.za


