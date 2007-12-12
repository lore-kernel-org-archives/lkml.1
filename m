Return-Path: <linux-kernel-owner+w=401wt.eu-S1757178AbXLLBJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178AbXLLBJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 20:09:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbXLLBJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 20:09:09 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42743 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbXLLBJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 20:09:07 -0500
Date: Tue, 11 Dec 2007 17:08:56 -0800
From: Gary Hade <garyhade@us.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: Gary Hade <garyhade@us.ibm.com>, Jan Beulich <jbeulich@novell.com>,
       linux-kernel@vger.kernel.org, lcm@us.ibm.com,
       linux-pci@atrey.karlin.mff.cuni.cz, j-nomura@ce.jp.nec.com
Subject: Re: Avoid creating P2P prefetch window for expansion ROMs
Message-ID: <20071212010856.GB6755@us.ibm.com>
References: <4742CB2C.76E4.0078.0@novell.com> <20071120174945.GA6024@us.ibm.com> <47440D1F.76E4.0078.0@novell.com> <20071126215953.GA23277@us.ibm.com> <20071126221545.GA15268@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071126221545.GA15268@suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2007 at 02:15:45PM -0800, Greg KH wrote:
> On Mon, Nov 26, 2007 at 01:59:54PM -0800, Gary Hade wrote:
> > Greg, 
> > Without a closer look at the code and the information I
> > requested above I am not 100% certain that my expansion ROM
> > allocation fix is incomplete but it seems pretty likely that
> > it is.  If you feel that the possible regression that Jan
> > reported is more important than the issue I was trying to solve
> > feel free to remove the change until I can come up with
> > something better.
> 
> If you want me to revert the changes in Linus's tree right now, that's
> fine, I will, just send me a patch to do so.
> 
> But if you think you can work to solve this problem quickly, then I'm
> more than willing to keep the changes in the tree.

Greg/Jan, This took me a little longer than I expected.
Thanks for your patience.

Because of the things that I learned from Jun'ichi Nomura
during our discussions in relation to his proposed 
"pci: Omit error message for benign allocation failure" change
( re: http://marc.info/?l=linux-kernel&m=119679719828284&w=2 )
and the below additional information that was provided by the
BIOS engineer who I have also been talking to about the problem,
I have decided to propose:
  1. Elimination of the default expansion ROM memory allocation
     attempts with old behavior accessible via pci=rom boot
     option.
  2. Revert my "Avoid creating P2P prefetch window for
     expansion ROMs" change to eliminate the type of
     regressions that Jan spotted for those that might
     want to force the old behavior with pci=rom.
Patches and more details for both of these to follow.

BIOS engineer said:
"Our BIOS is really not reserving any resources for the option roms.
BIOS used the non-prefetchable window to shadow the option rom.
So, there is room there for one option rom to be mapped at a time.
If multiple option roms are on the same bus, there may be room for
only one of them, as BIOS maps only one at a time to shadow it.

BIOS is grouping option rom bar with the non-prefetchable window,
because option rom bar and non-prefetchable window are 32-bit,
while prefetchable window could be 64-bit. Also, the spec doesn't
explicitly specify option rom bar as prefetchable. In fact, our BIOS
ensures DWORD aligned read during option rom scan & shadow,
as some devices had problem dealing with some alignment/size."

Thanks,
Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

