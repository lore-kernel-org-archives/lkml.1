Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab0CCVhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 16:37:32 -0500
Received: from cobra.newdream.net ([66.33.216.30]:39325 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab0CCVhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 16:37:24 -0500
Date: Wed, 3 Mar 2010 13:37:43 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: Christoph Hellwig <hch@infradead.org>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 23/26] ceph: nfs re-export support
In-Reply-To: <20100303074814.GA1030@infradead.org>
Message-ID: <Pine.LNX.4.64.1003031324310.20129@cobra.newdream.net>
References: <1267577217-31923-1-git-send-email-sage@newdream.net>
 <1267577217-31923-24-git-send-email-sage@newdream.net> <20100303074814.GA1030@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Mar 2010, Christoph Hellwig wrote:
> On Tue, Mar 02, 2010 at 04:46:54PM -0800, Sage Weil wrote:
> > Basic NFS re-export support is included.  This mostly works.  However,
> > Ceph's MDS design precludes the ability to generate a (small)
> > filehandle that will be valid forever, so this is of limited utility.
> 
> So don't include it if it's broken by design.

Well, there are changes we can make to the MDS to make it work that are on 
the roadmap (they'll also help with disaster recovery).  They will require 
some change on the client side, though, so it's not like the current 
implementation will suddenly work perfectly with a server-side upgrade.

That said, I don't think Ceph is the only filesystem that has this problem 
(fat? fuse? cifs?), and it is still useful in its current state.  But I 
can leave it off by default (via Kconfig option), or include a kern.log 
warning, or leave it out entirely, if that's what people prefer.

sage
