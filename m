Return-Path: <linux-kernel-owner+w=401wt.eu-S1757736AbYB1DWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736AbYB1DWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 22:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbYB1DWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 22:22:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40102 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139AbYB1DWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 22:22:11 -0500
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: benh@kernel.crashing.org
Subject: Re: [PATCH 1/2] firewire: endianess fix
Date: Wed, 27 Feb 2008 22:21:38 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Kristian Hoegsberg <krh@bitplanet.net>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net, Sam Ravnborg <sam@ravnborg.org>,
       Harvey Harrison <harvey.harrison@gmail.com>
References: <20080220220326.GA22328@uranus.ravnborg.org> <200802271458.28401.jwilson@redhat.com> <1204166422.15052.334.camel@pasglop>
In-Reply-To: <1204166422.15052.334.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802272221.38985.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 February 2008 09:40:22 pm Benjamin Herrenschmidt wrote:
> On Wed, 2008-02-27 at 14:58 -0500, Jarod Wilson wrote:
> > On Saturday 23 February 2008 06:24:17 am Stefan Richter wrote:
> > > The generation of incoming requests was filled in in wrong byte order
> > > on machines with big endian CPU.
> > >
> > > Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> > > Cc: sparclinux@vger.kernel.org
> > > Cc: linuxppc-dev@ozlabs.org
> > > ---
> > >
> > > This patch is a shot in the dark, based on a warning when building with
> > > C=1 CHECKFLAGS="-D__CHECK_ENDIAN__".  Is it really a fix, or was the
> > > previous code accidentally correct?
> > >
> > > This needs to be tested on different big endian PCs, if possible with
> > > the Apple Uninorth FireWire controller and other types of controllers.
> > > One test which involves ohci->request_generation is simply with an
> > > SBP-2 device (harddisk, CD-ROM...).  Does SBP-2 login etc. work?
> >
> > Works just fine with the Apple UniNorth controller in my powerbook in
> > cursory testing. Tested with multiple sbp2 hard disks, plugging and
> > unplugging, mounting and unmounting, etc.
>
> Which specific rev/version of the uninorth controller ?

lspci says Apple Computer Inc. UniNorth 2 FireWire (rev 81), pci id 106b:0031, 
subsys id 106b:5811.

(Its a circa 2004 Aluminum 15" PowerBook G4 @ 1.67GHz, fwiw).

> There is the "interesting" one has vendorID Apple and deviceID 0x0018,
> the normal ones have different deviceIDs (and are just lucent
> controllers afaik).

Under Mac OS X, system.log says "FireWire (OHCI) Apple ID 31 built-in now 
active". Could still be lucent though, judging by the subsys device ID of 
5811, which matches up w/the Lucent/Agere FW323. But no, apparently I don't 
have the interesting one.


-- 
Jarod Wilson
jwilson@redhat.com
