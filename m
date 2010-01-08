Return-Path: <linux-kernel-owner+w=401wt.eu-S1752261Ab0AHP1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab0AHP1c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 10:27:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891Ab0AHP1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 10:27:31 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:46836 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab0AHP1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 10:27:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=eEV/DEncrI5meCNUjmnaZaOkSWvTLQSnaGgK8bQJntW0nwyWFgx4y0eWmcuPlwwQW6
         ev1MV4AXXEyn/Cs8tl6vS7nha2wNmSCqkKtvNa2RSrUFx1v37Z1H6C5JpgbU7rGOYHSn
         oUsTn5nMKYgX2VI3AEgMOFpi7s+6GjUnf5Ae8=
Subject: Re: [PATCH 2/9] MTD: create lockless versions of
 {get,put}_mtd_device
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mtd <linux-mtd@lists.infradead.org>, Alex Dubov <oakad@yahoo.com>
In-Reply-To: <20100108152119.GB31872@logfs.org>
References: <1262963092.12577.14.camel@maxim-laptop>
	 <1262963198.12577.16.camel@maxim-laptop> <20100108152119.GB31872@logfs.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jan 2010 17:27:24 +0200
Message-ID: <1262964444.12577.29.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-08 at 16:21 +0100, Jörn Engel wrote: 
> On Fri, 8 January 2010 17:06:38 +0200, Maxim Levitsky wrote:
> >
> > +	err = __get_mtd_device(ret);
> 
> Function is called here, afaics not declared and defined...
> 
> > [...]
> > +int __get_mtd_device(struct mtd_info *mtd)
> 
> ...further below.  Didn't gcc complain about this?  Or am I missing
> something?
> 
> Jörn
> 

Yep, you miss this:

+extern int __get_mtd_device(struct mtd_info *mtd);
+extern void __put_mtd_device(struct mtd_info *mtd);

I put that into the header, so these functions can be used outside.

When I compiled the kernel, there were no warnings.

Best regards,
Maxim Levitsky

