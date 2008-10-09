Return-Path: <linux-kernel-owner+w=401wt.eu-S1754866AbYJIXIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbYJIXIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 19:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750754AbYJIXII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 19:08:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:38327 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbYJIXIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 19:08:05 -0400
Message-ID: <48EE8E55.4000009@kernel.org>
Date: Thu, 09 Oct 2008 16:05:57 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Grant Grundler <grundler@parisc-linux.org>
CC: Matthew Wilcox <matthew@wil.cx>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: print out DMA mask info
References: <1223506943-6543-1-git-send-email-yinghai@kernel.org> <20081009211837.GC18444@colo.lackof.org> <48EE7745.2020603@kernel.org> <20081009213551.GC25780@parisc-linux.org> <86802c440810091451y4a3caceg1abaa75464c40a72@mail.gmail.com> <20081009225533.GB1914@colo.lackof.org>
In-Reply-To: <20081009225533.GB1914@colo.lackof.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Grundler wrote:
> On Thu, Oct 09, 2008 at 02:51:32PM -0700, Yinghai Lu wrote:
>> On Thu, Oct 9, 2008 at 2:35 PM, Matthew Wilcox <matthew@wil.cx> wrote:
>>> Why's that interesting to the sysadmin of the machine?  To the driver
>>> writer, certainly.  But what's the use of it to the people using the
>>> machine?
> ...
>> make linux kernel act like black box as other os?
> 
> I don't understand your reply.
> If someone thinks linux is a black box, printing this message won't help them.
> 
could find out easily why some driver doesn't set dma mask correctly.
like why 
	qlogic qla2xxx only set consistent to 64bit,
	emulex lpfc not set consistent to 64bit
> 
> "To flag use of bounce buffer or other suboptimal behaviors" could be debated.
> 
> 
> Regarding associating the output with other PCI messages, I'd hope the fact
> that the /sys entry is in the same directory as other sys files would be
> enough clue to associate those together. e.g.:
> grundler <2068>cd /sys/bus/pci/devices/0000\:01\:00.0/
> grundler <2069>ls
> broken_parity_status  driver@  irq         resource0   subsystem_device
> bus@                  enable   local_cpus  resource1   subsystem_vendor
> class                 i2c-0/   modalias    resource3   uevent
> config                i2c-1/   power/      rom         vendor
> device                i2c-2/   resource    subsystem@
> 

add dma_mask coherent_dma_mask here?

YH
