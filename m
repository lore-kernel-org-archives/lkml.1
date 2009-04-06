Return-Path: <linux-kernel-owner+w=401wt.eu-S1753482AbZDFPTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbZDFPTr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 11:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbZDFPTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 11:19:35 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:7638 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbZDFPTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 11:19:34 -0400
Date: Mon, 6 Apr 2009 09:19:31 -0600
From: Alex Chiang <achiang@hp.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [git pull] PCI changes for 2.6.30
Message-ID: <20090406151931.GB25005@ldl.fc.hp.com>
References: <20090331121331.3673cf59@hobbes> <alpine.LFD.2.00.0904010957520.4130@localhost.localdomain> <20090401101309.67d0bea5@hobbes> <20090401183749.GC8188@ldl.fc.hp.com> <20090401191220.GB29673@uranus.ravnborg.org> <20090401222310.GA31290@ldl.fc.hp.com> <20090405193423.GB24374@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090405193423.GB24374@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sam Ravnborg <sam@ravnborg.org>:
> > 
> > Reading through Documentation/PCI/pci.txt says that under
> > CONFIG_HOTPLUG, __devinit should be a nop?
> The documentation is not up-to-date in this respect.
> 
> Annotating a function __devinit will no matter the configuration
> locate the code in a section named .devinit.text

Ok, I'll update the documentation.

> We then postprocess this section for illegal references using modpost.
> 
> The PCI_HOTPLUG code has often been troublesome with respect to these checks
> as this code is only relevant if CONFIG_HOTPLUG is enabled
> and will often not even be included in the kernel if not enabled.
> This is true for pci_rescan_bus() for example.
> 
> And we would like to export these symbols too. But we do not allow exported
> symbols to be annotated __devinit as this code will be blown away in some configurations.
> 
> So the correct solution which you also used in your patch is to tell
> modpost to ignore references to *init sections from this specific funtion
> as they are OK.

Does this count as an Acked-by?

Thanks.

