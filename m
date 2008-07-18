Return-Path: <linux-kernel-owner+w=401wt.eu-S1759312AbYGRWXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759312AbYGRWXk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbYGRWXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:23:32 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:17421 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbYGRWXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:23:31 -0400
Date: Fri, 18 Jul 2008 15:22:14 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: Joel.Becker@localdomain, Linus Torvalds <torvalds@linux-foundation.org>,
       Mark Fasheh <mfasheh@suse.com>, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Ocfs2-devel] [git patches] Ocfs2 and Configfs updates for
	2.6.27
Message-ID: <20080718222214.GB659@ca-server1.us.oracle.com>
Mail-Followup-To: Louis Rilling <Louis.Rilling@kerlabs.com>,
	Joel.Becker@localdomain,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mark Fasheh <mfasheh@suse.com>, linux-kernel@vger.kernel.org,
	ocfs2-devel@oss.oracle.com,
	Andrew Morton <akpm@linux-foundation.org>
References: <20080717175146.GH28014@wotan.suse.de> <alpine.LFD.1.10.0807171056520.2959@woody.linux-foundation.org> <20080717212038.GA8283@ca-server1.us.oracle.com> <20080717214512.GB8283@ca-server1.us.oracle.com> <20080717223018.GC8283@ca-server1.us.oracle.com> <20080718084803.GB3887@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080718084803.GB3887@localdomain>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 10:48:03AM +0200, Louis Rilling wrote:
> > Linus,
> > 	Pull this to get the revert and the PTR_ERR() version:
> > 
> > git://oss.oracle.com/git/jlbec/linux-2.6.git configfs-fixup-ptr-error
> > 
> > It's tested with the same testing I did before - ocfs2 and netconsole.
> 
> While this new version looks ok, it seems that it still allows client
> subsystems to return NULL in ->make_group()/->make_item(), in which case
> configfs_mkdir() turns the result into -ENOMEM. Maybe this is intended to
> smoothly update out-of-tree subsystems? I'd suggest to schedule a removal
> of this backward compatibility, and display an error log to encourage
> fixing the subsystems that still return NULL.

	It is precisely to keep out-of-tree modules from crashing.
There's no easy way to make them know it changed otherwise :-)  It could
certainly BUG or WARN before making the fixup.

Joel

-- 

"I'm drifting and drifting
 Just like a ship out on the sea.
 Cause I ain't got nobody, baby,
 In this world to care for me."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
