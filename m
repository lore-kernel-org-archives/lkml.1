Return-Path: <linux-kernel-owner+w=401wt.eu-S1754215AbXEBF1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbXEBF1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 01:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754638AbXEBF1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 01:27:43 -0400
Received: from outbound-mail-55.bluehost.com ([69.89.20.35]:43289 "HELO
	outbound-mail-55.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754215AbXEBF1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 01:27:42 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Olivier Galibert <galibert@pobox.com>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard resources
Date: Tue, 1 May 2007 22:27:31 -0700
User-Agent: KMail/1.9.6
Cc: Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
References: <4635510D.4060103@shaw.ca> <200705011941.07438.jbarnes@virtuousgeek.org> <200705011956.30629.jbarnes@virtuousgeek.org>
In-Reply-To: <200705011956.30629.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705012227.31729.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.73.10 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 01, 2007, Jesse Barnes wrote:
> > I'm testing it now on my 965...
>
> Bah... nevermind Robert, I see you're doing this already in
> pci_mmcfg_reject_broken.  I'm about to reboot & test now.

Ok, I've tested a bit on my 965 (after re-adding my old patch to support 
it) and the new checks are more complete, but my BIOS still appears to be 
buggy.

The extended config space (as defined by the register) is at 0xf0000000 
(full value is 0xf0000003 indicating 128M enabled).  The ACPI MCFG table 
has this space reserved according to Robert's new code, but the machine 
hangs due to the address space aliasing Olivier mentioned awhile back.  I 
don't have a PCIe card to test with (or any devices that require extended 
config space that I know of) so I can't really tell if Windows supports 
PCIe on this platform, but if it does I don't see how it would w/o having 
a full bridge driver and sophisticated address space allocation builtin.

I'm going to try updating my BIOS, but if that doesn't solve this problem, 
I'm not sure what we can do about it.  Should pci_mmcfg_insert_resources 
check for conflicts?  Should we just blacklist certain boards?  I can try 
pinging our BIOS folks about this board to see what was intended, but I'm 
sure this won't be the only board we have problems with, so we'll need to 
address it generically somehow.

Thanks,
Jesse
