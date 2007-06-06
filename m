Return-Path: <linux-kernel-owner+w=401wt.eu-S934939AbXFFSlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934939AbXFFSlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 14:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758473AbXFFSlC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 14:41:02 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:6958 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762894AbXFFSlA (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 14:41:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZRNE0DfrNUIhVBOyKzWxdgUIn9UDxyOTQ+lb8lh8It9fRNoqc8BhAdfSudfnTTM8mSB5oR10Bnwo8tMQzuIU7vWDU19nuj5pvXhSWolqJDNJb9X8kFgYqx1HLAvvW0BFzuE39ybE+p+k0fYbX3bAtEvzxJVWwZ6LgAcSzBXsvEs=
Message-ID: <6934efce0706061140r4ed8436nf71d9b4aaf5c565e@mail.gmail.com>
Date: Wed, 6 Jun 2007 11:40:58 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>, carsteno@de.ibm.com,
       "Jared Hulbert" <jaredeh@gmail.com>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       "Richard Griffiths" <res07ml0@verizon.net>,
       Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
In-Reply-To: <20070606162305.GA20600@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1179871779.24163.11.camel@localhost.localdomain>
	 <4653F264.1030807@de.ibm.com> <465BB5BA.3050900@yahoo.com.au>
	 <6934efce0706011748p46cf7995vdca0b9cc3f0b06a3@mail.gmail.com>
	 <46612D6F.6000002@yahoo.com.au> <46641472.3080802@de.ibm.com>
	 <6934efce0706060413y6e74512s19d5f468106d4b85@mail.gmail.com>
	 <20070606113351.GA11701@infradead.org> <4666DD88.5030708@de.ibm.com>
	 <20070606162305.GA20600@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  The embedded people already use them
> on flash which is a little dumb, but now we add even more cludge for
> a non-block based access.

Please justify your assertion that using cramfs on flash is dumb.
What would be not dumb?  In an embedded system with addressable Flash
the linear addressing cramfs is simple and elegant solution.

Removing support for block based access would drastically reduce the
complexity of cramfs.  The non-block access bits of code are trivial
in comparison.  Specifically which part of my patch represents
unwarranted, unfixable cludge?

> The right way to architect xip for flash-based devices is to implement
> a generic get_xip_page for mtd-based devices and integrate that into
> an existing flash filesystem or write a simple new flash filesystem
> tailored to that use case.

There is often no need for the complexity of the MTD for a readonly
compressed filesystem in the embedded world.   I am intrigued by the
suggestion of a generic get_xip_page() for mtd-based devices.  I fail
to see how get_xip_page() is not highly filesystem dependant.  How
might a generic one work?
