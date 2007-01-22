Return-Path: <linux-kernel-owner+w=401wt.eu-S932155AbXAVWAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155AbXAVWAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 17:00:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932108AbXAVWAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 17:00:04 -0500
Received: from ns1.suse.de ([195.135.220.2]:54810 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932094AbXAVWAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 17:00:01 -0500
From: Neil Brown <neilb@suse.de>
To: Chuck Ebbert <cebbert@redhat.com>
Date: Tue, 23 Jan 2007 08:59:36 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17845.13256.284461.992275@notabene.brown>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Kernel 2.6.19.2 New RAID 5 Bug (oops when writing Samba -> RAID5)
In-Reply-To: message from Chuck Ebbert on Monday January 22
References: <Pine.LNX.4.64.0701200718290.29223@p34.internal.lan>
	<45B5261B.1050104@redhat.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday January 22, cebbert@redhat.com wrote:
> Justin Piszcz wrote:
> > My .config is attached, please let me know if any other information is 
> > needed and please CC (lkml) as I am not on the list, thanks!
> >
> > Running Kernel 2.6.19.2 on a MD RAID5 volume.  Copying files over Samba to 
> > the RAID5 running XFS.
> >
> > Any idea what happened here?
....
> >   
> Without digging too deeply, I'd say you've hit the same bug Sami Farin 
> and others
> have reported starting with 2.6.19: pages mapped with kmap_atomic() 
> become unmapped
> during memcpy() or similar operations.  Try disabling preempt -- that 
> seems to be the
> common factor.

That is exactly the conclusion I had just come to (a kmap_atomic page
must be being unmapped during memcpy).  I wasn't aware that others had
reported it - thanks for that.

Turning off CONFIG_PREEMPT certainly seems like a good idea.

NeilBrown
