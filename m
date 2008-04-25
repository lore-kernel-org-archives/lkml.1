Return-Path: <linux-kernel-owner+w=401wt.eu-S1763614AbYDYRMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763614AbYDYRMM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 13:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbYDYRL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 13:11:59 -0400
Received: from outbound-mail-144.bluehost.com ([67.222.38.34]:34650 "HELO
	outbound-mail-144.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753184AbYDYRL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 13:11:59 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: pci commands resume order [Was: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff]
Date: Fri, 25 Apr 2008 10:11:51 -0700
User-Agent: KMail/1.9.9
Cc: Jiri Slaby <jirislaby@gmail.com>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
References: <alpine.LFD.1.10.0804241841280.2779@woody.linux-foundation.org> <20080425.004523.146850490.davem@davemloft.net> <481193EF.9050308@gmail.com>
In-Reply-To: <481193EF.9050308@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804251011.52542.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 63.227.221.253 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 25, 2008 1:18 am Jiri Slaby wrote:
> On 04/25/2008 09:45 AM, David Miller wrote:
> > I notice Jiri, in your hardware list, you have an ath5k Atheros AR5212
> > chip in there.
> >
> > I took a look at the resume code for ath5k but nothing really suspicious
> > there except:
> >
> > 	err = pci_enable_device(pdev);
> > 	if (err)
> > 		return err;
> >
> > 	pci_restore_state(pdev);
> >
> > Shouldn't we restore state before we turn the chip back on and thus
> > potentially let it start DMA'ing all over the place?
>
> Hmm, actually every second wireless driver do this :/. I think it's wrong
> too. Jesse?

It might be a little safer to enable the device after restoring its state, but 
if your device starts DMAing randomly when going from D3->D0 it's probably 
not a very good device. :)

> BTW pci_set_power_state(pdev, PCI_D0); in resume isn't needed at all,
> right? It's done in pci_enable_device, isn't it?

Right, pci_enable_device will put the device in D0, so setting it again is 
redundant (looks like lots of drivers do this).

Jesse
