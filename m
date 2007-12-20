Return-Path: <linux-kernel-owner+w=401wt.eu-S1760736AbXLTUPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760736AbXLTUPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 15:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760096AbXLTUPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 15:15:31 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:45556 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760231AbXLTUPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 15:15:30 -0500
Date: Thu, 20 Dec 2007 13:15:29 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Loic Prylli <loic@myri.com>
Cc: Tony Camuso <tcamuso@redhat.com>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
Message-ID: <20071220201529.GJ29690@parisc-linux.org>
References: <476A5FD0.4010804@redhat.com> <20071220172205.GB5636@suse.de> <20071220173528.GE29690@parisc-linux.org> <476AAE99.7090301@redhat.com> <20071220181603.GF29690@parisc-linux.org> <476AB920.7040604@myri.com> <476ABCBF.8090006@redhat.com> <20071220190833.GH29690@parisc-linux.org> <476ACB20.6030803@myri.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476ACB20.6030803@myri.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 03:05:52PM -0500, Loic Prylli wrote:
> I am not familiar with the tg3 driver, just trying to give a 5 minutes
> look, it seems the typical cases where the pci-conf-space is used
> intensively are with some rev in combination with the 82801
> (TG3_FLG2_ICH_WORKAROUND) which I don't think support mmconfig anyway,
> as well as some very specific PCI-X combinations
> (TG3_FLAG_PCIX_TARGET_HWBUG) which are also very unlikely to support
> mmconfig.

It's not a question of whether the card supports mmconfig or not -- the
card can't tell whether a first-256-byte pci config transaction was
initiated through mmconfig, type1, type2, or even a bios call.

I'm just hacking together an implementation based on Ivan's suggestion
to always use type 1 for the first 64 bytes.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
