Return-Path: <linux-kernel-owner+w=401wt.eu-S1752507AbYJTPMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbYJTPMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 11:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbYJTPMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 11:12:13 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:37908 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbYJTPMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 11:12:12 -0400
Date: Mon, 20 Oct 2008 10:12:01 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: david safford <safford@watson.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 2/3] integrity: Linux Integrity Module(LIM)
Message-ID: <20081020151201.GA2899@us.ibm.com>
References: <cover.1223869200.git.zohar@localhost.localdomain> <7c05f813215804a30d03821fd8e251b250d0e000.1223869200.git.zohar@localhost.localdomain> <20081014132823.GA18474@infradead.org> <1223998072.3089.53.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223998072.3089.53.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting david safford (safford@watson.ibm.com):
> On Tue, 2008-10-14 at 09:28 -0400, Christoph Hellwig wrote:
> > >  }
> > >  
> > >  /*
> > > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > > index 32477e8..349d548 100644
> > > --- a/include/linux/fs.h
> > > +++ b/include/linux/fs.h
> > > @@ -683,6 +683,9 @@ struct inode {
> > >  #ifdef CONFIG_SECURITY
> > >  	void			*i_security;
> > >  #endif
> > > +#ifdef CONFIG_INTEGRITY
> > > +	void			*i_integrity;
> > > +#endif
> > 
> > Sorry, but as said before bloating the inode for this is not an option.
> > Please use something like the MRU approach I suggested in the last
> > review round.
> 
> Sorry, in that thread I thought we were ok, as Serge made the points
> that the bloat would only affect Integrity compiled kernels, that
> no one would press for making Integrity default (not only because of the
> bloat, but even more so because of the performance impact of hashing
> all the files), and that having LIM do MRU would be a big hit, as
> LIM allocates i_integrity for all inodes, and references it on all
> inode_permission, bprm and mmap calls.  

Yes I have to say that in this case, where every inode will have the
field in use, using MRU doesn't seem to make sense.  It's the ideal
case for putting it straight in the inode.

But I hear Mimi is trying it out, so she can report about any
resulting implementation and performance problems.

> If we have to, we have to, but we certainly would prefer not to.
> 
> thanks
> dave
