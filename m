Return-Path: <linux-kernel-owner+w=401wt.eu-S932398AbXCHSWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398AbXCHSWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 13:22:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932414AbXCHSWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 13:22:24 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:34047 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932398AbXCHSWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 13:22:23 -0500
Subject: Re: [RFC][Patch 2/6] integrity: fs hook placement
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
       safford@watson.ibm.com, serue@linux.vnet.ibm.com,
       kjhall@linux.vnet.ibm.com, zohar@us.ibm.com
In-Reply-To: <20070308174036.GF10574@sequoia.sous-sol.org>
References: <1173369812.5981.2.camel@localhost.localdomain>
	 <20070308164132.GL6602@sequoia.sous-sol.org>
	 <20070308170733.GA21099@sergelap.austin.ibm.com>
	 <20070308174036.GF10574@sequoia.sous-sol.org>
Content-Type: text/plain
Date: Thu, 08 Mar 2007 13:34:42 -0500
Message-Id: <1173378882.5981.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-08 at 09:40 -0800, Chris Wright wrote:
> * Serge E. Hallyn (serue@us.ibm.com) wrote:
> > Are you objecting only to the duplication at the callsites, so that an
> > fsnotify-type of consolidation of security and integrity hooks would be
> > ok?  Or are you complaining that the security_inode_setxattr and
> > integrity_inode_setxattr hooks are too similar anyway, and integrity
> > modules should just use some lsm hooks for anything which will be
> > authoritative?
> 
> It's duplication of callsites with many identical implementations
> that's the problem.
>
> > (I could see an argument that integirty subsystem should be purely for
> > measuring and hence its hooks should never return a value.  Only hitch
> > there is that if integrity subsystem hits ENOMEM it should be able to
> > refuse the action...)
> 
> Right, that's what I was expecting to see, just the measurement
> infrastructure.

There are a total of 10 Linux Integrity Module(LIM) hooks. Seven of
which parallel the LSM hooks, out of the ~150 LSM hooks.  3 of the LIM
hooks are for initializing, allocating, and freeing the inode-
>i_integrity, used for caching integrity information.  As the integrity
information is stored as extended attributes, 2 hooks are for catching
changes to the extended attributes, one is for updating the extended
attributes when the file closes, and d_instantiate is used for
initialization.  Is this excessive?  How else would you design
integrity, without using the LSM hooks?

Mimi Zohar


