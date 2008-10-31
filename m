Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208AbYJaQWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbYJaQWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 12:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbYJaQW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 12:22:29 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:59022 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbYJaQW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 12:22:29 -0400
Date: Fri, 31 Oct 2008 11:22:25 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 2/3] integrity: Linux Integrity Module(LIM)
Message-ID: <20081031162225.GA17790@us.ibm.com>
References: <cover.1223869200.git.zohar@localhost.localdomain> <7c05f813215804a30d03821fd8e251b250d0e000.1223869200.git.zohar@localhost.localdomain> <20081014132823.GA18474@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081014132823.GA18474@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Christoph Hellwig (hch@infradead.org):
> >  /*
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index 32477e8..349d548 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -683,6 +683,9 @@ struct inode {
> >  #ifdef CONFIG_SECURITY
> >  	void			*i_security;
> >  #endif
> > +#ifdef CONFIG_INTEGRITY
> > +	void			*i_integrity;
> > +#endif
> 
> Sorry, but as said before bloating the inode for this is not an option.
> Please use something like the MRU approach I suggested in the last
> review round.

Hi Christoph, Mimi is looking into uinsg a tree but is still trying to
get the locking right.  So in the meantime I just have to ask again -
for something which will always be either compiled out, or filled in for
every inode, why have the overhead of having an external cache?  Either
the i_integrity won't be compiled in, or you'll have to go through the
external cache for every inode operation anyway.  It doesn't make sense
to me...  Is there a case I'm missing that risks getting hard-hit here
(performance-wise), or is this mainly a style thing?

thanks,
-serge
