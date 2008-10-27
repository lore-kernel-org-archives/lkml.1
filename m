Return-Path: <linux-kernel-owner+w=401wt.eu-S1752604AbYJ0PXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbYJ0PXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 11:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbYJ0PXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 11:23:21 -0400
Received: from os.eurotux.com ([216.75.63.6]:33491 "EHLO os.eurotux.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbYJ0PXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 11:23:20 -0400
Date: Mon, 27 Oct 2008 15:18:18 +0000
From: Luciano Rocha <luciano@eurotux.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       SCSI development list <linux-scsi@vger.kernel.org>
Subject: Re: usb hdd problems with 2.6.27.2
Message-ID: <20081027151818.GA4044@bit.office.eurotux.com>
Mail-Followup-To: Luciano Rocha <luciano@eurotux.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux-Kernel <linux-kernel@vger.kernel.org>,
	USB list <linux-usb@vger.kernel.org>,
	SCSI development list <linux-scsi@vger.kernel.org>
References: <20081027112803.GA4398@bit.office.eurotux.com> <Pine.LNX.4.44L0.0810271007030.4059-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.44L0.0810271007030.4059-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.14 (2007-03-31)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2008 at 10:24:14AM -0400, Alan Stern wrote:
> On Mon, 27 Oct 2008, Luciano Rocha wrote:
> 
> > On Sat, Oct 25, 2008 at 03:50:07PM -0400, Alan Stern wrote:
> > > On Sat, 25 Oct 2008, Rafael J. Wysocki wrote:
> > > 
> > > > [Adding CCs]
> > > > 
> > > > On Wednesday, 22 of October 2008, Luciano Rocha wrote:
> > > > > 
> > > > > Hello,
> > > > > 
> > > > > An external HDD, usb-encased, works fine under 2.6.26.5, but under
> > > > > 2.6.27.2 I get hundreds of errors per second, of 'No Sense [current]'.
> > > 
> > > You can use usbmon to capture the details of what happens when you plug
> > > in the drive.  Instructions are in the kernel source file
> > > Documentation/usb/usbmon.txt.
> > > 
> > 
> > Now in 2.6.27.4, same problem. The usb traffic is:
> 
> This looks exactly like the "infinite retry" problem I warned about 
> earlier.  Here are the important parts of the log.  For people who 
> don't know how to interpret these messages, the CDB starts in the 16th 
> byte of the 31-byte messages.  For example, the first command here 
> starts with 0x25 and so it is READ CAPACITY:
> 
> > f21e7cc0 3570408174 S Bo:1:008:1 -115 31 = 55534243 06000000 08000000 80000a25 00000000 00000000 00000000 000000
> > f21e7cc0 3570408264 C Bo:1:008:1 0 31 >
> > f21e72c0 3570408280 S Bi:1:008:2 -115 8 <
> > f21e72c0 3570408389 C Bi:1:008:2 0 8 = 2e9390b0 00000200
> > f21e7cc0 3570408400 S Bi:1:008:2 -115 13 <
> > f21e7cc0 3570408513 C Bi:1:008:2 0 13 = 55534253 06000000 00000000 00
> 
> The response is 0x2e9390b0.  In typical broken fashion, that is 
> undoubtedly the total number of sectors rather than the highest sector 
> number.
> 
> Later on the system tries to read the contents of what it thinks is the 
> last sector:

Hm, where in the code can I change it to return less that what it thinks
is the last sector?

<snip>
> 
> There's a patch which might help resolve this problem:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=8bfa24727087d7252f9ecfb5fea2dfc92d797fbd
> 

No luck. I'm going to try 2.6.28-rc2 now.

Regards,
Luciano Rocha

-- 
Luciano Rocha <luciano@eurotux.com>
Eurotux Informática, S.A. <http://www.eurotux.com/>
