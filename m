Return-Path: <linux-kernel-owner+w=401wt.eu-S1753736AbYJaQwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbYJaQwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 12:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbYJaQvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 12:51:51 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:55254 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbYJaQvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 12:51:50 -0400
Subject: Re: [PATCH 2/3] integrity: Linux Integrity Module(LIM)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <20081014132823.GA18474@infradead.org>
References: <cover.1223869200.git.zohar@localhost.localdomain>
	 <7c05f813215804a30d03821fd8e251b250d0e000.1223869200.git.zohar@localhost.localdomain>
	 <20081014132823.GA18474@infradead.org>
Content-Type: text/plain
Date: Fri, 31 Oct 2008 09:51:42 -0700
Message-Id: <1225471902.12673.415.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-14 at 09:28 -0400, Christoph Hellwig wrote:
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -683,6 +683,9 @@ struct inode {
> >  #ifdef CONFIG_SECURITY
> >       void                    *i_security;
> >  #endif
> > +#ifdef CONFIG_INTEGRITY
> > +     void                    *i_integrity;
> > +#endif
> 
> Sorry, but as said before bloating the inode for this is not an option.
> Please use something like the MRU approach I suggested in the last
> review round.

Why don't we just have a 'void *i_lots_of_bloat field', and let the
security folks stick whatever they want in it?  They can trade their
i_security space for a new one.  I know we want to conceptually separate
security from integrity, so let's separate it:

struct i_bloat_inodes {
#ifdef CONFIG_SECURITY
	void                    *i_security;
#endif
#ifdef CONFIG_INTEGRITY
	void                    *i_integrity;
#endif
};

By the way, if there's no TPM hardware, why would I want i_integrity
anyway?

-- Dave

