Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbXLDVtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbXLDVtb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:49:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754584AbXLDVtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:49:17 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:56500 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754074AbXLDVtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:49:16 -0500
Date: Tue, 4 Dec 2007 13:49:07 -0800
From: Gary Hade <garyhade@us.ibm.com>
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       Greg KH <gregkh@suse.de>, jbeulich@novell.com
Subject: Re: [PATCH] pci: Omit error message for benign allocation failure
Message-ID: <20071204214907.GB9194@us.ibm.com>
References: <4755AC14.20605@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4755AC14.20605@ce.jp.nec.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 02:35:48PM -0500, Jun'ichi Nomura wrote:
> Hi,
> 
> On a system with PCI-to-PCI bridges, following errors are observed:
> 
> PCI: Failed to allocate mem resource #8:100000@d8200000 for 0000:02:00.0
> PCI: Failed to allocate mem resource #6:10000@0 for 0000:03:01.0
> 
> '#6' is for expansion ROM and '#8' for the bridge where the device
> with the expansion ROM is connected.

I believe there is a good chance that may be another instance
of the regression caused by my "Avoid creating P2P prefetch
window for expansion ROMs" patch that was recently reported by
Jan Beulich.
  http://marc.info/?l=linux-kernel&m=119555581103023&w=2

You might want to try reverting my changes to see if the
problem disappears.

I am working on a better fix for the problem that the patch
was attempting to address but this is turning out to be much
more difficult than I expected.  If I don't have a solution
very soon I plan to publish a revert patch.

> But I think the failure is benign because the allocation is
> not necessary for these resources.

This is an interesting idea.  Could you elaborate?  As far
as I can tell, the kernel always tries to allocate memory
for expansion ROMs which it also exports to user level.
I have assumed that some drivers or user level apps may
need to access this space.  Is this not true?

If this is due to my change, sorry for the trouble.

Thanks,
Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc
