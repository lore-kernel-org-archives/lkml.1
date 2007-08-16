Return-Path: <linux-kernel-owner+w=401wt.eu-S1764820AbXHPJpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764820AbXHPJpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 05:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754399AbXHPJpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 05:45:05 -0400
Received: from mx1.suse.de ([195.135.220.2]:40390 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814AbXHPJpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 05:45:03 -0400
Date: Thu, 16 Aug 2007 11:45:11 +0200
From: Bernhard Walle <bwalle@suse.de>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] add kdump_after_notifier
Message-ID: <20070816094511.GA28545@suse.de>
Mail-Followup-To: kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <20070802112852.GA7054@in.ibm.com> <31687.1186113947@kao2.melbourne.sgi.com> <20070805110746.GA12540@in.ibm.com> <46C1691E.7090708@ah.jp.nec.com> <20070814083710.GA14538@suse.de> <20070814132454.GA8293@in.ibm.com> <46C4184B.5030303@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C4184B.5030303@ah.jp.nec.com>
Organization: SUSE LINUX Products GmbH
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Takenori Nagano <t-nagano@ah.jp.nec.com> [2007-08-16 11:26]:
> Vivek Goyal wrote:
> > - Modify Kdump to register on die_chain list. 
> > - Modify Kdb to register on die_chain list.
> > - Export all the registered members of die_chain through sysfs along with
> >   their priorities. Priorities should be modifiable. Most likely one 
> >   shall have to introduce additional field in struct notifier_block. This
> >   field will be a string as an identifier of the user registerd. e.g
> >   "Kdump", "Kdb" etc.
> > 
> > Now user will be able to view all the die_chain users through sysfs and
> > be able to modify the order in which these should run by modifying their
> > priority. Hence all the RAS tools can co-exist.
> 
> This is my image of your proposal.
> 
> - Print current order
> 
> # cat /sys/class/misc/debug/panic_notifier_list
> priority   name
> 1          IPMI
> 2          watchdog
> 3          Kdb
> 4          Kdump

I think something like

/sys/class/misc/debug/panic_notifier/ipmi/priority
/sys/class/misc/debug/panic_notifier/watchdog/priority
/sys/class/misc/debug/panic_notifier/kdb/priority
/sys/class/misc/debug/panic_notifier/kdump/priority

would be better. It's more self-describing if you want to change the
order.



Thanks,
   Bernhard

