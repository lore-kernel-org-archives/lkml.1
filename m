Return-Path: <linux-kernel-owner+w=401wt.eu-S1756362AbYJIWz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362AbYJIWz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 18:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750816AbYJIWzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 18:55:49 -0400
Received: from colo.lackof.org ([198.49.126.79]:39149 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbYJIWzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 18:55:48 -0400
Date: Thu, 9 Oct 2008 16:55:33 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: print out DMA mask info
Message-ID: <20081009225533.GB1914@colo.lackof.org>
References: <1223506943-6543-1-git-send-email-yinghai@kernel.org> <20081009211837.GC18444@colo.lackof.org> <48EE7745.2020603@kernel.org> <20081009213551.GC25780@parisc-linux.org> <86802c440810091451y4a3caceg1abaa75464c40a72@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440810091451y4a3caceg1abaa75464c40a72@mail.gmail.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2008 at 02:51:32PM -0700, Yinghai Lu wrote:
> On Thu, Oct 9, 2008 at 2:35 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> > Why's that interesting to the sysadmin of the machine?  To the driver
> > writer, certainly.  But what's the use of it to the people using the
> > machine?
...
> make linux kernel act like black box as other os?

I don't understand your reply.
If someone thinks linux is a black box, printing this message won't help them.

"To flag use of bounce buffer or other suboptimal behaviors" could be debated.


Regarding associating the output with other PCI messages, I'd hope the fact
that the /sys entry is in the same directory as other sys files would be
enough clue to associate those together. e.g.:
grundler <2068>cd /sys/bus/pci/devices/0000\:01\:00.0/
grundler <2069>ls
broken_parity_status  driver@  irq         resource0   subsystem_device
bus@                  enable   local_cpus  resource1   subsystem_vendor
class                 i2c-0/   modalias    resource3   uevent
config                i2c-1/   power/      rom         vendor
device                i2c-2/   resource    subsystem@

means all those files refer to the same device. lspci is just a nice
wrapper to format/dump that info and perhaps help people associate
different bits of available info.

hth,
grant


> 
> YH
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
