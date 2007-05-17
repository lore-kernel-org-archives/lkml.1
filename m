Return-Path: <linux-kernel-owner+w=401wt.eu-S1760908AbXEQDFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760908AbXEQDFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 23:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758584AbXEQDFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 23:05:24 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:47875
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758520AbXEQDFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 23:05:23 -0400
From: Rob Landley <rob@landley.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
Date: Wed, 16 May 2007 23:05:11 -0400
User-Agent: KMail/1.9.1
Cc: Tejun Heo <htejun@gmail.com>, Dave Jones <davej@redhat.com>,
       Francesco Pretto <ceztko@gmail.com>, Phillip Susi <psusi@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <fa.Ia7dfo7Zd5kB6KhSYisfswa1aj4@ifi.uio.no> <200705161948.56497.rob@landley.net> <20070517005842.GC600@khazad-dum.debian.net>
In-Reply-To: <20070517005842.GC600@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200705162305.11755.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 May 2007 8:58 pm, Henrique de Moraes Holschuh wrote:
> On Wed, 16 May 2007, Rob Landley wrote:
> > Ok, so the change is to get shutdown to _stop_ doing something stupid 
> > (spinning down the disk without first flushing the cache), and the correct 
> > thing for shutdown to do is keep its' mitts off the thing and let the 
kernel 
> > power down the darn hardware?
> 
> Yes, for *all* SCSI disk devices, libata or not.

I realize that this time next year it won't be possible to use a ramdisk or a 
network block device without going through the SCSI layer, but while it 
remains an option I'm relishing _not_ using it, thanks.

> But you need to detect if the kernel has proper SCSI device shutdown
> support, because if it does not, you have to do a cache flush and spindown
> on shutdown(8) if you can...

Or (and this is just a thought), you could upgrade your kernel so it correctly 
handles your hardware, treating this just like any other driver bug or other 
lack of proper hardware support in the history of Linux.  (Back when APM 
couldn't power off the machine at the end of the shutdown sequence, did we 
modify shutdown to try to work around this, or did we fix it in the kernel so 
it worked?)

Why does everybody want to shoehorn everything through the SCSI layer, anyway?  
Last I checked you didn't have to spin down a USB flash key.  If SATA is 
SCSI, what the heck is SAS?  (Answer: a cynical marketing hack to bleed SCSI 
bigots for the huge margins they've always been bled for.  But oh well.)  It 
would be hilarious if I didn't have to put up with it renumbering my devices 
and imposing requirements for hardware I haven't got on hardware I have 
got...

Rob
