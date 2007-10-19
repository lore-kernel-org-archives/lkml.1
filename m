Return-Path: <linux-kernel-owner+w=401wt.eu-S966234AbXJSDiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966234AbXJSDiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 23:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934165AbXJSDiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 23:38:46 -0400
Received: from koto.vergenet.net ([210.128.90.7]:53336 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933686AbXJSDip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 23:38:45 -0400
Date: Fri, 19 Oct 2007 12:38:42 +0900
From: Simon Horman <horms@verge.net.au>
To: tachibana@mxm.nes.nec.co.jp
Cc: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>,
       Don Zickus <dzickus@redhat.com>, Neil Horman <nhorman@redhat.com>,
       Dan Aloni <da-x@monatomic.org>, Bernhard Walle <bwalle@suse.de>,
       kexec-ml <kexec@lists.infradead.org>,
       lkml <linux-kernel@vger.kernel.org>, Vivek Goyal <vgoyal@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] [kexec-tools] Pass vmcoreinfo's address and size
Message-ID: <20071019033842.GG692@verge.net.au>
References: <20071018053739.GA31244@verge.net.au> <20071018181407tachibana@mail.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018181407tachibana@mail.jp.nec.com>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2007 at 06:14:07PM +0900, tachibana@mxm.nes.nec.co.jp wrote:
> 
> Hi Simon,
> 
> On Thu, 18 Oct 2007 14:37:41 +0900, Simon Horman <horms@verge.net.au> wrote:
> > On Wed, Oct 17, 2007 at 02:16:19PM +0900, Ken'ichi Ohmichi wrote:
> > > 
> > > Hi Simon,
> > > 
> > > Simon Horman wrote:
> > > > On Wed, Aug 22, 2007 at 09:13:39PM +0900, Ken'ichi Ohmichi wrote:
> > > >> [2/3] [kexec-tools] Pass vmcoreinfo's address and size
> > > >> The patch is for kexec-tools-testing-20070330.
> > > >> (http://www.kernel.org/pub/linux/kernel/people/horms/kexec-tools/)
> > > >> kexec command gets the address and size of the vmcoreinfo data from
> > > >> /sys/kernel/vmcoreinfo, and passes them to the second kernel through
> > > >> ELF header of /proc/vmcore. When the second kernel is booting, the
> > > >> kernel gets them from the ELF header and creates vmcoreinfo's PT_NOTE
> > > >> segment into /proc/vmcore.
> > > > 
> > > > Sorry for the long delay, I completely missed this patch.
> > > > 
> > > > The kexec-tools change seems ok to me. What is the status of
> > > > the kernel portion of the change?
> > > 
> > > The kernel portion is merged into linux-2.6.23-mm1.
> > > According to Andrew's mail "-mm merge plans for 2.6.24",  its status is
> > > "The infamous misc.  Will re-review and will merge basically all of them".
> > > 
> > > http://www.ussg.iu.edu/hypermail/linux/kernel/0710.0/0313.html
> > > 
> > > 
> > > > Do you still want the kexec-tools portion applied?
> > > 
> > > Yes, I hope so.
> > 
> > Thanks, applied :-)
> 
> Thank you for applying ;-)
> 
> But it has the compatibility problem that the kexec command fails on
> kernels which don't have /sys/kernel/vmcoreinfo:
> 
>  # ls /sys/kernel/
>  debug  kexec_crash_loaded  kexec_loaded  security  uevent_helper 
>  uevent_seqnum
>  #
>  (There is not /sys/kernel/vmcoreinfo.)
> 
>  #
>  # kexec -p --args-linux vmlinuz --initrd=initrd.img
>  Could not open "/sys/kernel/vmcoreinfo": No such file or directory
>  #
> 
> To fix the problem, could you please apply the attached patch ?
> The fixed part is the same as the patch in the following mail.

Thanks, applied.
