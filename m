Return-Path: <linux-kernel-owner+w=401wt.eu-S1759419AbXLTTIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759419AbXLTTIq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 14:08:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbXLTTIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 14:08:35 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:48068 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbXLTTIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 14:08:35 -0500
Date: Thu, 20 Dec 2007 12:08:33 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Tony Camuso <tcamuso@redhat.com>
Cc: Loic Prylli <loic@myri.com>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
Message-ID: <20071220190833.GH29690@parisc-linux.org>
References: <476A5FD0.4010804@redhat.com> <20071220172205.GB5636@suse.de> <20071220173528.GE29690@parisc-linux.org> <476AAE99.7090301@redhat.com> <20071220181603.GF29690@parisc-linux.org> <476AB920.7040604@myri.com> <476ABCBF.8090006@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476ABCBF.8090006@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 02:04:31PM -0500, Tony Camuso wrote:
> Also, this solution also would allow us to remove the unreachable_devices()
> routine and bitmap.

Not really ... we probe reading address 0x100 to see if the device
supports extended config space or not.  So we need to make that fail
gracefully for the amd7111 case.

> Does anybody see a down side to this?

It'll be slower than it would be if we used mmconfig directly.  Now yes,
nobody should be using pci config space in performance critical paths
... but see the tg3 driver.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
