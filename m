Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934AbYHHBQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbYHHBQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 21:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbYHHBQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 21:16:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbYHHBQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 21:16:04 -0400
Date: Thu, 7 Aug 2008 21:15:00 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Keith Owens <kaos@ocs.com.au>
Cc: Andi Kleen <andi@firstfloor.org>, Jay Lan <jlan@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>, jmerkey@wolfmountaingroup.com,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
       Takenori Nagano <t-nagano@ah.jp.nec.com>,
       Bernhard Walle <bwalle@suse.de>
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
Message-ID: <20080808011500.GA531@redhat.com>
References: <20080807200659.GJ24801@one.firstfloor.org> <23175.1218148134@ocs10w>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23175.1218148134@ocs10w>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 08:28:54AM +1000, Keith Owens wrote:
> Andi Kleen (on Thu, 7 Aug 2008 22:06:59 +0200) wrote:
> >> To merge KDB or any other RAS tools, you need to deal with kdump. Kdump
> >> hijack panic() before the die calling chain. For KDB or a RAS tool to
> >
> >Imho kdump should just be fixed to use die chains.
> 
> Violently agree, especially since the IA64 handling of NMI type
> events is significantly different from x86 and requires at least two
> callbacks via the die chain.
> 
> Alas the kdump authors are adamant that they will not use die chains,
> which makes it almost impossible for any other RAS code to coexist with
> kdump.  This intransigence on the part of kdump is one of the reasons
> that I gave up on getting _any_ RAS code (not just KDB) into the Linux
> kernel.
> 

I am doing a quick source code grep and in all the cases except panic,
kdump gets a chance to run in the end. We are running die notifications
first. For example, in the case of nmi, in the case of traps,
in the case of mce, notifier list is being executed first. So a debugger
or any other RAS tool on the notifier chain will get a chance to
run first.
 
panic() is the only place where kdump gets a chance to run first and
panic notifiers are not executed.

To me so far only in kernel debugger seems to be a reasonable candiate
which needs to run before kdump after a panic event. If a debugger
is really getting merged into the kernel, then I think debugger can
put a hook in the panic() before kdump. Wouldn't this solve the problem?

Thanks
Vivek
