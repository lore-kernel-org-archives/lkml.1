Return-Path: <linux-kernel-owner+w=401wt.eu-S1758960AbYB1CJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758960AbYB1CJk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 21:09:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755395AbYB1CJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 21:09:30 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:59911 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293AbYB1CJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 21:09:29 -0500
Subject: Re: [PATCH 05/11] NFSv4: Add label recommended attribute and NFSv4
	flags
From: Dave Quigley <dpquigl@tycho.nsa.gov>
To: James Morris <jmorris@namei.org>
Cc: hch@infradead.org, viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no,
       bfields@fieldses.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <Xine.LNX.4.64.0802281247130.27221@us.intercode.com.au>
References: <1204150294-4678-1-git-send-email-dpquigl@tycho.nsa.gov>
	 <1204150294-4678-6-git-send-email-dpquigl@tycho.nsa.gov>
	 <Xine.LNX.4.64.0802281247130.27221@us.intercode.com.au>
Content-Type: text/plain
Date: Wed, 27 Feb 2008 20:45:12 -0500
Message-Id: <1204163112.24345.40.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-28 at 12:52 +1100, James Morris wrote:
> On Wed, 27 Feb 2008, David P. Quigley wrote:
> 
> > +#define NFS4_MAXLABELLEN	255
> 
> I remember raising this before, but I think we need to try and find a 
> better way to implement this than always allocating labels of a fixed and 
> possibly too-small size.
> 
> What about perhaps starting with a statically allocated array of say 64 
> bytes (I can't see any labels on my system larger than that), and then 
> falling back to a a dynamic allocation of up to 32k if it turns out to be 
> too small ?  i.e. large labels are a slow path and there is no practical 
> limit on label size.
> 
> 
> - James

I'm not convinced that it is worth all of that extra logic just to save
some space on a transient data structure. 255 characters seems to be
overkill to begin with considering you don't often get a label like the
one below which is only 90 characters.

thisismyuser_u:withseveralroles_r:andanoverlylongtype_t:s0-s12:c0,c1,c2,c3,c4,c5,c6,c7,c8

