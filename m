Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbZIFIfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbZIFIfi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 04:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754685AbZIFIfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 04:35:38 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:34402 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641AbZIFIfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 04:35:36 -0400
Date: Sun, 6 Sep 2009 01:32:50 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: [patch 41/48] ocfs2: Initialize the cluster were writing to in
 a non-sparse extend
Message-ID: <20090906083249.GA20761@mail.oracle.com>
Mail-Followup-To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
	stable@kernel.org, stable-review@kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, Sunil Mushran <sunil.mushran@oracle.com>
References: <20090904200712.724048145@mini.kroah.org>
 <20090904200856.335297402@mini.kroah.org>
 <20090904210040.GA945@mail.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904210040.GA945@mail.oracle.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4AA37410.00FA:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04, 2009 at 02:00:40PM -0700, Joel Becker wrote:
> On Fri, Sep 04, 2009 at 01:07:53PM -0700, Greg KH wrote:
> > 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > From: Sunil Mushran <sunil.mushran@oracle.com>
> > 
> > commit e7432675f8ca868a4af365759a8d4c3779a3d922 upstream.
> > 
> > In a non-sparse extend, we correctly allocate (and zero) the clusters between
> > the old_i_size and pos, but we don't zero the portions of the cluster we're
> > writing to outside of pos<->len.
> > 
> > It handles clustersize > pagesize and blocksize < pagesize.
> > 
> > [Cleaned up by Joel Becker.]
> 
> Greg, et al,
> 	Yesterday we found a bug in this patch.  The patch still fixes
> the original problem, but we introduced an error in certain
> page_mkwrite() corner cases.  We have one more validation test and then
> I'm sending the fix to Linus.
> 	So we really want both this commit and the followup fix in
> -stable.  You'll be CC'd when I send Linus the pull request.

	Ok, the fix is upstream, commit
8379e7c46cc48f51197dd663fc6676f47f2a1e71.  It applies on top of this
patch, and is needed for both stable trees.

Joel

-- 

Life's Little Instruction Book #335

	"Every so often, push your luck."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
