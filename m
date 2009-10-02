Return-Path: <linux-kernel-owner+w=401wt.eu-S1755497AbZJBPzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbZJBPzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 11:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754967AbZJBPzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 11:55:24 -0400
Received: from cobra.newdream.net ([66.33.216.30]:53920 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908AbZJBPzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 11:55:23 -0400
Date: Fri, 2 Oct 2009 08:55:27 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Andi Kleen <andi@firstfloor.org>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, yehuda@newdream.net
Subject: Re: [PATCH 19/21] ceph: ioctls
In-Reply-To: <87ske2sa2n.fsf@basil.nowhere.org>
Message-ID: <Pine.LNX.4.64.0910020840180.16283@cobra.newdream.net>
References: <1253641129-28434-1-git-send-email-sage@newdream.net>
 <1253641129-28434-5-git-send-email-sage@newdream.net>
 <1253641129-28434-6-git-send-email-sage@newdream.net>
 <1253641129-28434-7-git-send-email-sage@newdream.net>
 <1253641129-28434-8-git-send-email-sage@newdream.net>
 <1253641129-28434-9-git-send-email-sage@newdream.net>
 <1253641129-28434-10-git-send-email-sage@newdream.net>
 <1253641129-28434-11-git-send-email-sage@newdream.net>
 <1253641129-28434-12-git-send-email-sage@newdream.net>
 <1253641129-28434-13-git-send-email-sage@newdream.net>
 <1253641129-28434-14-git-send-email-sage@newdream.net>
 <1253641129-28434-15-git-send-email-sage@newdream.net>
 <1253641129-28434-16-git-send-email-sage@newdream.net>
 <1253641129-28434-17-git-send-email-sage@newdream.net>
 <1253641129-28434-18-git-send-email-sage@newdream.net>
 <1253641129-28434-19-git-send-email-sage@newdream.net>
 <1253641129-28434-20-git-send-email-sage@newdream.net> <87ske2sa2n.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Oct 2009, Andi Kleen wrote:

> Sage Weil <sage@newdream.net> writes:
> > +/*
> > + * Extract identity, address of the OSD and object storing a given
> > + * file offset.
> > + */
> > +struct ceph_ioctl_dataloc {
> > +	__u64 file_offset;           /* in+out: file offset */
> > +	__u64 object_offset;         /* out: offset in object */
> > +	__u64 object_no;             /* out: object # */
> > +	__u64 object_size;           /* out: object size */
> > +	char object_name[64];        /* out: object name */
> > +	__u64 block_offset;          /* out: offset in block */
> > +	__u64 block_size;            /* out: block length */
> > +	__s64 osd;                   /* out: osd # */
> > +	struct sockaddr_in osd_addr; /* out: osd address */
> 
> You'll have to revise that once you support IPv6. At least extend the structure
> better now? (_in is too small for IPv6)

Yes.  I suspect an explicit

	struct in6_addr osd_addr;
	__be16 osd_port;

makes more sense.  Then legacy IPv4 addresses can just be represented as 
::ffff:1.2.3.4.  That seems like the simplest route?

I should similarly update the struct ceph_entity_addr as well (it also 
embeds a sockaddr_in).  And/or embed that struct here.

sage
