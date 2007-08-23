Return-Path: <linux-kernel-owner+w=401wt.eu-S1759435AbXHWDwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435AbXHWDwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 23:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756100AbXHWDwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 23:52:15 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:47813 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755996AbXHWDwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 23:52:14 -0400
Date: Thu, 23 Aug 2007 09:22:27 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Takenori Nagano <t-nagano@ah.jp.nec.com>
Cc: Keith Owens <kaos@ocs.com.au>, "Eric W. Biederman" <ebiederm@xmission.com>,
       k-miyoshi@cb.jp.nec.com, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Bernhard Walle <bwalle@suse.de>
Subject: Re: [patch] add kdump_after_notifier
Message-ID: <20070823035227.GA365@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070802112852.GA7054@in.ibm.com> <31687.1186113947@kao2.melbourne.sgi.com> <20070805110746.GA12540@in.ibm.com> <46C1691E.7090708@ah.jp.nec.com> <20070814083710.GA14538@suse.de> <20070814132454.GA8293@in.ibm.com> <46C4184B.5030303@ah.jp.nec.com> <20070817105630.GA18167@in.ibm.com> <46CA97FE.90505@ah.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CA97FE.90505@ah.jp.nec.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 04:45:02PM +0900, Takenori Nagano wrote:
> Vivek Goyal wrote:
> > On Thu, Aug 16, 2007 at 06:26:35PM +0900, Takenori Nagano wrote:
> >> Vivek Goyal wrote:
> >>  > So for the time being I think we can put RAS tools on die notifier list
> >>> and if it runs into issues we can always think of creating a separate list.
> >>>
> >>> Few things come to mind.
> >>>
> >>> - Why there is a separate panic_notifier_list? Can't it be merged with
> >>>   die_chain? die_val already got one of the event type as PANIC. If there
> >>>   are no specific reasons then we should merge the two lists. Registering
> >>>   RAS tools on a single list is easier.
> >> I think it is difficult, because die_chain is defined by each architecture.
> >>
> > 
> > I think die_chain is arch independent definition (kernel/die_notifier.c)? 
> > But anyway, to begin with it can be done only for panic_notifier.
> 
> I think die_val (notify_die() argument) values are arch independent.
> They are defined in include/asm-<arch>/kdebug.h.
> 
> Your idea is good, but I think it has very large impact. It is very hard to fix
> them at the same time. So, how about putting off merging two lists?
> 

I think that's fine. For the time being we can just export panic_notifier
list. die_chain is not a problem as of today as die notifiers get invoked
first and then if panic_on_oops is set, kdump is called. So all the RAS
tools registered on die_chain will get executed first.

Thanks
Vivek
