Return-Path: <linux-kernel-owner+w=401wt.eu-S932786AbZGPQ6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786AbZGPQ6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 12:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932614AbZGPQ6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 12:58:34 -0400
Received: from cobra.newdream.net ([66.33.216.30]:33804 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932582AbZGPQ6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 12:58:33 -0400
Date: Thu, 16 Jul 2009 09:58:32 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Andi Kleen <andi@firstfloor.org>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/20] ceph: on-wire types
In-Reply-To: <878wiox10x.fsf@basil.nowhere.org>
Message-ID: <Pine.LNX.4.64.0907160951420.7645@cobra.newdream.net>
References: <1247693090-27796-1-git-send-email-sage@newdream.net>
 <1247693090-27796-2-git-send-email-sage@newdream.net>
 <1247693090-27796-3-git-send-email-sage@newdream.net> <878wiox10x.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jul 2009, Andi Kleen wrote:
> Sage Weil <sage@newdream.net> writes:
> > +
> > +/*
> > + * Max file size is a policy choice; in reality we are limited
> > + * by 2^64.
> > + */
> > +#define CEPH_FILE_MAX_SIZE (1ULL << 40)   /* 1 TB */
> 
> Seems odd to hardcode this here.

It is.  It's just an arbitrary value to bound recovery time... I'll switch 
it a server-specified value.

> The way attribute packed is used in these files seems rather
> random and adhoc, sometimes it is, sometimes it isn't.

Not intentionally, it looks like it was missing on some structs 
that were already naturally aligned.  I'll add it everywhere.

> I assume you tested that 32bit and 64bit interoperability?

Yes.

> Is the file system supposed to be endian safe on the wire?

Yes, although I don't have access to any big endian machines, so it hasn't 
been tested.  We've been periodically running the code through sparse, 
though.

Thanks!
sage
