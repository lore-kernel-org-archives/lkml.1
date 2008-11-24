Return-Path: <linux-kernel-owner+w=401wt.eu-S1754025AbYKXXKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbYKXXKB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 18:10:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbYKXXJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 18:09:52 -0500
Received: from gir.skynet.ie ([193.1.99.77]:58702 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344AbYKXXJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 18:09:51 -0500
Date: Mon, 24 Nov 2008 23:09:48 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: petkovbb@gmail.com, sshtylyov@ru.mvista.com, linux-kernel@vger.kernel.org
Subject: Re: Is the change to IDE probing really necessary?
Message-ID: <20081124230948.GB8293@csn.ul.ie>
References: <20081124155632.GE23190@csn.ul.ie> <20081124184321.GA8293@csn.ul.ie> <20081124185453.57ca7dcc@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20081124185453.57ca7dcc@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2008 at 06:54:53PM +0000, Alan Cox wrote:
> O> On a machine requiring probing of the legacy ports, the suggested
> > probe_mask of 0x3f results in other devices being registered as IDE
> > devices. Suggest to the user they use 0x3 which is the old value of
> > probe_mask prior to commit 20df429dd6671804999493baf2952f82582869fa.
> 
> NAK
> 
> This makes no sense.
> 

Ok.

> 0x3F means probe them all.
> 
> 0x03 means only peer at primary/secondary.
> 

Then can the message outputted printed out say something along those
lines? On this particular machine, probing 0x3F resulted in a misconfigured
machine. It's not obvious to me at all that 0x3F means probe everything,
possibly with adverse results and 0x03 means peer at primary/secondary.

> If you don't want them probed, don't pass arguments asking for them to be
> probed!
> 
> "how is a distro install using modules meant to be fixed up?"
> 
> If the distribution supports non PCI bus boxes then pass a mask of 0x3F
> on non PCI boxes.

Which in this case would have resulted in a machine with a disk but no
networking. CONFIG_ISA is not even set on this machine and it looks like a
PCI bus box.

> If the distribution is for PCI systems then leave the
> mask alone.
> 

Which in this case resulted in no disk because the mask defaults to 0
now instead of 0x3 or anything else.

What you suggest for the numbers in each case is right, but it's not
obvious. The machine might be so old that no will encounter this problem
in practice.

> If you want it to just work automatically use pata_legacy instead as that
> automatically flips between probing ISA tertiary devices and leaving
> things well alone according to the presence of PCI bus.
> 

It doesn't find the disk.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
