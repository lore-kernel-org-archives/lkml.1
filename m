Return-Path: <linux-kernel-owner+w=401wt.eu-S1756010AbZDFTOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbZDFTOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 15:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbZDFTOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 15:14:35 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:56995 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbZDFTOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 15:14:34 -0400
Date: Mon, 6 Apr 2009 21:16:36 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Alex Chiang <achiang@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [git pull] PCI changes for 2.6.30
Message-ID: <20090406191636.GA2366@uranus.ravnborg.org>
References: <20090331121331.3673cf59@hobbes> <alpine.LFD.2.00.0904010957520.4130@localhost.localdomain> <20090401101309.67d0bea5@hobbes> <20090401183749.GC8188@ldl.fc.hp.com> <20090401191220.GB29673@uranus.ravnborg.org> <20090401222310.GA31290@ldl.fc.hp.com> <20090405193423.GB24374@uranus.ravnborg.org> <20090406151931.GB25005@ldl.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090406151931.GB25005@ldl.fc.hp.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 06, 2009 at 09:19:31AM -0600, Alex Chiang wrote:
> * Sam Ravnborg <sam@ravnborg.org>:
> > > 
> > > Reading through Documentation/PCI/pci.txt says that under
> > > CONFIG_HOTPLUG, __devinit should be a nop?
> > The documentation is not up-to-date in this respect.
> > 
> > Annotating a function __devinit will no matter the configuration
> > locate the code in a section named .devinit.text
> 
> Ok, I'll update the documentation.
> 
> > We then postprocess this section for illegal references using modpost.
> > 
> > The PCI_HOTPLUG code has often been troublesome with respect to these checks
> > as this code is only relevant if CONFIG_HOTPLUG is enabled
> > and will often not even be included in the kernel if not enabled.
> > This is true for pci_rescan_bus() for example.
> > 
> > And we would like to export these symbols too. But we do not allow exported
> > symbols to be annotated __devinit as this code will be blown away in some configurations.
> > 
> > So the correct solution which you also used in your patch is to tell
> > modpost to ignore references to *init sections from this specific funtion
> > as they are OK.
> 
> Does this count as an Acked-by?
If this is not too late - yes.

	Sam
