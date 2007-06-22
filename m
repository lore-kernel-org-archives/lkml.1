Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbXFVCZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbXFVCZQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 22:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbXFVCZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 22:25:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:35303 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbXFVCZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 22:25:03 -0400
From: Neil Brown <neilb@suse.de>
To: Bill Davidsen <davidsen@tmr.com>
Date: Fri, 22 Jun 2007 12:24:45 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18043.13037.40956.366334@notabene.brown>
Cc: david@lang.hm, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: limits on raid
In-Reply-To: message from Bill Davidsen on Thursday June 21
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>
	<18034.479.256870.600360@notabene.brown>
	<Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm>
	<18034.3676.477575.490448@notabene.brown>
	<46756BE2.7010401@tmr.com>
	<467B03C1.50809@tmr.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday June 21, davidsen@tmr.com wrote:
> I didn't get a comment on my suggestion for a quick and dirty fix for 
> -assume-clean issues...
> 
> Bill Davidsen wrote:
> > How about a simple solution which would get an array on line and still 
> > be safe? All it would take is a flag which forced reconstruct writes 
> > for RAID-5. You could set it with an option, or automatically if 
> > someone puts --assume-clean with --create, leave it in the superblock 
> > until the first "repair" runs to completion. And for repair you could 
> > make some assumptions about bad parity not being caused by error but 
> > just unwritten.

It is certainly possible, and probably not a lot of effort.  I'm not
really excited about it though.

So if someone to submit a patch that did the right stuff,  I would
probably accept it, but I am unlikely to do it myself.


> >
> > Thought 2: I think the unwritten bit is easier than you think, you 
> > only need it on parity blocks for RAID5, not on data blocks. When a 
> > write is done, if the bit is set do a reconstruct, write the parity 
> > block, and clear the bit. Keeping a bit per data block is madness, and 
> > appears to be unnecessary as well.

Where do you propose storing those bits?  And how many would you cache
in memory?  And what performance hit would you suffer for accessing
them?  And would it be worth it?

NeilBrown
