Return-Path: <linux-kernel-owner+w=401wt.eu-S1752788AbYHHPFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbYHHPFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 11:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbYHHPFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 11:05:43 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60953 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752305AbYHHPFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 11:05:42 -0400
Date: Fri, 8 Aug 2008 10:06:02 -0500
From: Cliff Wickman <cpw@sgi.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, Keith Owens <kaos@ocs.com.au>,
       Jay Lan <jlan@sgi.com>, Christoph Lameter <cl@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>, jmerkey@wolfmountaingroup.com,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
       Takenori Nagano <t-nagano@ah.jp.nec.com>,
       Bernhard Walle <bwalle@suse.de>
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
Message-ID: <20080808150602.GB20352@sgi.com>
References: <20080807200659.GJ24801@one.firstfloor.org> <23175.1218148134@ocs10w> <20080808011500.GA531@redhat.com> <20080808022916.GM24801@one.firstfloor.org> <20080808120813.GA17364@sgi.com> <20080808122052.GA9038@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080808122052.GA9038@one.firstfloor.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 02:20:52PM +0200, Andi Kleen wrote:
> > In a partitioned system [I work for SGI, so I'm talking about an Altix],
> > there is memory sharing among multiple single-system images. And if
> > one of those partitions were to panic the other partitions need to
> > be informed that they cannot address the panic'd partition's memory.
> > (Once that partition is rebooted any such access will cause an MCA
> > in the accessor.)
> 
> There are already existing shutdown hooks. Aren't they good enough
> for that?

For shutdown, yes.  But on a panic crash_kexec() gets called
before the panic_notifier_list is run.
 
> I would feel uneasy about having arbitary drivers hook into panic().
> While I'm sure your code is great there is unfortunately a lot 
> of crappy driver code around.

That is Eric Biederman's concern as well.  But it seems we should
have a way for a user/customer to customize those events and their order,
as I noted in a previous post.

-- 
Cliff Wickman
Silicon Graphics, Inc.
cpw@sgi.com
(651) 683-3824
