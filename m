Return-Path: <linux-kernel-owner+w=401wt.eu-S1756662AbZFWJxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662AbZFWJxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 05:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbZFWJxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 05:53:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:18201 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbZFWJxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 05:53:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=G0KHCMjeh48bSiAvRMUBOeGbgR8W8s8WzB2ZsHwoeJNi0BgKDTmkx2sFHl8IoKn38a
         H3tV7KvLm2LjwhcBXCbdIAQ583qsyLOX/ZCwOF/Uei7UklTH4fTq/yG34U5/PcydPtER
         Gpa2GRvuFYLHUkQwIZNEp33+M4a36vsvl3CpE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] cs5520: add missing IRQ setup for the second port
Date: Tue, 23 Jun 2009 11:59:01 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090619-10934-gace1e80-dirty; KDE/4.2.3; i686; ; )
Cc: Frans Pop <elendil@planet.nl>, David Miller <davem@davemloft.net>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200906221348.02632.bzolnier@gmail.com> <200906230158.12805.elendil@planet.nl> <20090623094206.4d1f1b5b@lxorguk.ukuu.org.uk>
In-Reply-To: <20090623094206.4d1f1b5b@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906231159.01295.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 June 2009 10:42:06 Alan Cox wrote:
> On Tue, 23 Jun 2009 01:58:11 +0200
> Frans Pop <elendil@planet.nl> wrote:
> 
> > David Miller wrote:
> > > ide_pci_setup_ports() would loop over the available ports, one
> > > by one, recording IRQ numbers increasingly from the one passed
> > > in as "pciirq".
> > 
> > I looked at the commit and at the code and called functions several times 
> > (just out of curiosity), but have been completely unable to find where 
> > that increase of pciirq actually happened.
> > AFAICT ide_pci_setup_ports() just passed it on to ide_hw_configure() and 
> > all that did was 'hw->irq = irq', so AFAICT in the old case both ports 
> > would get the *same* IRQ, and not consecutive ones.
> 
> The cs5520 isn't a standard IDE controller in the first place and doesn't
> have two channels anyway. It's special as it uses non standard bar

Please note that both cs5520.c / pata_cs5520.c assume that the controller
has two ports (please verify whether they need some fixing, thanks)..
