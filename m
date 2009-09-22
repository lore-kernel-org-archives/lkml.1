Return-Path: <linux-kernel-owner+w=401wt.eu-S1752193AbZIVTuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbZIVTuW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbZIVTuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:50:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37071 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbZIVTuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:50:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] PCI PM: Read device power state from register after updating it (rev. 2)
Date: Tue, 22 Sep 2009 21:51:35 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200909212337.01812.rjw@sisk.pl> <20090922091620.599ab046@infradead.org>
In-Reply-To: <20090922091620.599ab046@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909222151.36022.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 September 2009, Arjan van de Ven wrote:
> On Mon, 21 Sep 2009 23:37:01 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> >  
> > -	dev->current_state = state;
> > +	pci_read_config_word(dev, dev->pm_cap + PCI_PM_CTRL, &pmcsr);
> > +	dev->current_state = (pmcsr & PCI_PM_CTRL_STATE_MASK);
> > +	/* Return error code if we have failed to change the state */
> > +	if (dev->current_state != state)
> > +		dev_info(&dev->dev, "Refused to change power state, "
> > +			"currently in D%d\n", dev->current_state);
> 
> I would suspect that you want this message only once...
> to avoid it flooding logs and such

Hmm?  I don't think we use pci_set_power_state() _that_ often.

> or at least ratelimiting it

That sounds like a good idea, though, will respin.
