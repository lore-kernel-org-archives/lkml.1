Return-Path: <linux-kernel-owner+w=401wt.eu-S937011AbXFGVTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937011AbXFGVTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 17:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762882AbXFGVT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 17:19:29 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:42158 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760090AbXFGVT3 (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 17:19:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tx4QpgDi2UPm1TX922jDKEkf4CjxcRxwGn8DQ26+CplaxlSQEAvt6GqfFyfYtUZU5P96rV0K2PCur6GnLgO+EhqWeGNlYei9BidFn2q+GDBZ6pwe4ky4TlmOnX0LUqCXBTy8lKSDUSdtODO6SZPaEhZ1kw+VFjYcnvv9LsDVOU4=
Message-ID: <6934efce0706071419n2557603cl85e820d0612787a@mail.gmail.com>
Date: Thu, 7 Jun 2007 14:19:28 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: carsteno@de.ibm.com
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
Cc: "Christoph Hellwig" <hch@infradead.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       "Richard Griffiths" <res07ml0@verizon.net>,
       Linux-kernel@vger.kernel.org
In-Reply-To: <46683B6A.6030306@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1179871779.24163.11.camel@localhost.localdomain>
	 <465BB5BA.3050900@yahoo.com.au>
	 <6934efce0706011748p46cf7995vdca0b9cc3f0b06a3@mail.gmail.com>
	 <46612D6F.6000002@yahoo.com.au> <46641472.3080802@de.ibm.com>
	 <6934efce0706060413y6e74512s19d5f468106d4b85@mail.gmail.com>
	 <20070606113351.GA11701@infradead.org> <4666DD88.5030708@de.ibm.com>
	 <20070606162305.GA20600@infradead.org> <46683B6A.6030306@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I've had a few beer long discussion with Joern Engel and David
> Woodhouse on this one. To cut a long discussion short: the current XIP
> infrastructure is not sufficient to be used on top of mtd. We'd need
> some extenstions:
> - on get_xip_page() we'd need to state if we want the reference
> read-only or read+write
> - we need a put_xip_page() to return references
> - and finally we need a callback for the referece, so that the mtd
> driver can ask to get its reference back (in order to unmap from
> userland when erasing a block)

Yes. And one more thing.  We can't assume every page in a file is XIP or not.

However, I still can't get even the existing get_xip_page() to work
for me so we are getting ahead of ourselves;)  Looking back on this
thread I realize I haven't confirmed if my cramfs_get_xip_page() gets
a page struct.  I assume that is my problem?  The UML find_iomem()
probably returns psuedo iomem with page structs.  While ioremap() does
not return with page struct backed memory.
