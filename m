Return-Path: <linux-kernel-owner+w=401wt.eu-S1755983AbZFRAhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbZFRAhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 20:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbZFRAho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 20:37:44 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:40029 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbZFRAhn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 20:37:43 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Organization: Mandriva
To: fmhess@users.sourceforge.net
Subject: Re: staging driver s626 clashes with philips SAA7146 media/dvb based cards
Date: Wed, 17 Jun 2009 21:37:43 -0300
User-Agent: KMail/1.11.90 (Linux/2.6.30-desktop-1mnb; KDE/4.2.90; i686; ; )
Cc: Ian Abbott <abbotti@mev.co.uk>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Gianluca Palli <gpalli@deis.unibo.it>, David Schleef <ds@schleef.org>
References: <200906161701.45234.herton@mandriva.com.br> <200906172105.57000.herton@mandriva.com.br> <200906172021.51400.fmhess@speakeasy.net>
In-Reply-To: <200906172021.51400.fmhess@speakeasy.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <200906172137.43870.herton@mandriva.com.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Qua 17 Jun 2009, às 21:21:51, Frank Mori Hess escreveu:
> On Wednesday 17 June 2009, you wrote:
> > >
> > > This patch looks buggy.  It's changing the logic beyond just checking
> > > for subvendor/subdevice ids.
> >
> > That's the intention here, so that it avoids someone adding a new pci id
> > without specifying either subvendor or subdevice id for 0x1131:0x7146
> > boards, but yes there will be a problem if boards with vendor:id not
> > equal to 0x1131:0x7146 appear in future, as you will be obliged to add
> > subvendor:subdevice id even if not needed.
> 
> Your patch breaks configuration of the board unless the bus and slot are 
> explicitly specified.  Just make a minimal patch that replaces 
> pci_get_device with pci_get_subsys and fixes the problem that was 
> reported.

Hmm that's not what the patch does, it doesn't break configuration, keeps
the same logic as before (I was wrong in my last email replying to myself),
check it, if it->options[0] and it->options[1] isn't specified, the pdev is
valid so the for loop exits (see !pdev check).

> 
> > If not wanted and it gone too far, I can revert to use the same logic as
> > pci_match_id, or just simplify this in case it's unlikely more s626
> > boards appear.
> >
> > The current situation is ugly, comedi subsystem could have a better way
> > to deal with hotplug and probe of devices, without you having to
> > reimplement what pci subsystem functions already does.
> 
> Agreed, it's currently in a limbo between trying to support auto probing of 
> devices and supporting comedi's old way of configuring hardware.  But I 
> don't anticipate you are going to refactor the comedi core and all the 
> drivers, so just make a minimal patch that doesn't change any logic it 
> doesn't need to.
> 
> 
