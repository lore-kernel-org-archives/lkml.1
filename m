Return-Path: <linux-kernel-owner+w=401wt.eu-S1756795AbZIVSVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbZIVSVm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 14:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756216AbZIVSVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 14:21:41 -0400
Received: from cobra.newdream.net ([66.33.216.30]:47738 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745AbZIVSVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 14:21:41 -0400
Date: Tue, 22 Sep 2009 11:21:44 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Joe Perches <joe@perches.com>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, yehuda@newdream.net
Subject: Re: [PATCH 02/21] ceph: on-wire types
In-Reply-To: <1253642496.30020.58.camel@Joe-Laptop.home>
Message-ID: <Pine.LNX.4.64.0909221120300.1552@cobra.newdream.net>
References: <1253641129-28434-1-git-send-email-sage@newdream.net>
 <1253641129-28434-2-git-send-email-sage@newdream.net>
 <1253641129-28434-3-git-send-email-sage@newdream.net>
 <1253642496.30020.58.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Sep 2009, Joe Perches wrote:

> On Tue, 2009-09-22 at 10:38 -0700, Sage Weil wrote:
> > These headers describe the types used to exchange messages between the
> > Ceph client and various servers.  All types are little-endian and
> > packed.
> []
> > diff --git a/fs/ceph/ceph_fs.h b/fs/ceph/ceph_fs.h
> > new file mode 100644
> > index 0000000..15150fc
> > --- /dev/null
> > +++ b/fs/ceph/ceph_fs.h
> []
> > +static inline __u32 frag_make(__u32 b, __u32 v)
> > +{
> > +	return (b << 24) |
> > +		(v & (0xffffffu << (24-b)) & 0xffffffu);
> > +}
> 
> frag_<foo> inlines might have a conflict with ipv6

I'll prefix those with 'ceph_'.

> > +static inline const char *ceph_mds_state_name(int s)
> > +{
> > +	switch (s) {
> []
> > +	case CEPH_MDS_STATE_STOPPING:   return "up:stopping";
> > +	default: return "";
> > +	}
> > +	return NULL;
> > +}
> 
> inline?
> 
> It's probably better not to use inlines here
> as the strings could be duplicated unnecessarily.

Agreed.  They were easier to maintain that way when the constants changed 
frequently, but they can be uninlined now.

Thanks!
sage
