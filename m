Return-Path: <linux-kernel-owner+w=401wt.eu-S1946357AbXBIKlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946357AbXBIKlG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 05:41:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946341AbXBIKlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 05:41:06 -0500
Received: from twin.jikos.cz ([213.151.79.26]:39241 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946357AbXBIKlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 05:41:04 -0500
Date: Fri, 9 Feb 2007 11:40:27 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Andrew Morton <akpm@linux-foundation.org>
cc: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>,
       linux-kernel@vger.kernel.org, linux-aio <linux-aio@kvack.org>,
       Zach Brown <zach.brown@oracle.com>, suparna@in.ibm.com,
       Chris Mason <chris.mason@oracle.com>,
       Badari Pulavarty <pbadari@us.ibm.com>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] aio: fix kernel bug when page is  temporally busy
In-Reply-To: <20070209021444.2213deb6.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702091137530.25686@twin.jikos.cz>
References: <B41635854730A14CA71C92B36EC22AAC8048C3@mssmsx411>
 <Pine.LNX.4.64.0702091042330.25686@twin.jikos.cz>
 <20070209021444.2213deb6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Feb 2007, Andrew Morton wrote:

> > @@ -1204,7 +1204,7 @@ generic_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
> >  			do_generic_file_read(filp,ppos,&desc,file_read_actor);
> >  			retval += desc.written;
> >  			if (desc.error) {
> > -				retval = retval ?: desc.error;
> > +				retval = desc.error;
> >  				break;
> >  			}
> Nope.  On error the read() syscall must return the number of bytes which
> were successfully read.

You are right. 

In current mainline this even is not a problem, because noone seems to be 
setting the error values to EIOCBRETRY. But it still stinks a bit, as 
there are tests for EIOCBRETRY.

-- 
Jiri Kosina
