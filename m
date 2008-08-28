Return-Path: <linux-kernel-owner+w=401wt.eu-S1756869AbYH1W2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869AbYH1W2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 18:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756507AbYH1W2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 18:28:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:54961 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771AbYH1W2G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 18:28:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] usb: add Freescale QE/CPM USB peripheral controller driver
Date: Fri, 29 Aug 2008 00:27:58 +0200
User-Agent: KMail/1.9.9
Cc: Scott Wood <scottwood@freescale.com>, dbrownell@users.sourceforge.net,
       greg@kroah.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Li Yang <leoli@freescale.com>
References: <Pine.LNX.4.44L0.0808281613540.3844-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0808281613540.3844-100000@iolanthe.rowland.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808290027.59127.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+NSStdv0AH415ECBJbOszN7JpDHpExGuysgA4
 ZrzgPXOtkDijx64oouLjEjd+lzQKLtRaqvroWd+e+vWcI1XeEu
 LmENyLUPv741nF9hSFRPg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 August 2008, Alan Stern wrote:
> On Thu, 28 Aug 2008, Scott Wood wrote:
> 
> > Alan Stern wrote:
> > > This was done deliberately.  The relevant standards state that a USB
> > > device can have no more than one peripheral interface.
> > 
> > Does building a kernel image that can run on different hardware without 
> > rebuilding also violate the "relevant standards"?
> 
> No.  That isn't what Arnd was concerned about.  He noted that even if 
> you did build multiple modules, only one of them could be loaded at any 
> time.

Well, actually it was exactly what I was concerned about ;-)

The way I understand the code, it is layered into the hardware specific
part and the protocol specific part, which are connected through
the interfaces I pointed out.

The standard requires that there can only be one protocol handler
per physical interface, which is a reasonable limitation.
However, what the Linux implementation actually enforces is
that there can only be one hardware specific driver built or loaded
into the kernel, which just looks like an arbitrary restriction
that does not actually help.

If the gadget hardware drivers were registering the device with a
gadget_bus_type, you could still enforce the "only one protocol"
rule by binding every protocol to every device in that bus type.

	Arnd <><
