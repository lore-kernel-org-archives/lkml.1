Return-Path: <linux-kernel-owner+w=401wt.eu-S1754831AbYKGTWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbYKGTWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 14:22:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbYKGTWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 14:22:44 -0500
Received: from el-out-1112.google.com ([209.85.162.182]:26761 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbYKGTWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 14:22:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LkOdyAavZ0JJVcxNKu8XaqKdhgU9vgeDe8LGEJ7oWDvMLpjvXfc9ttD+dTY9BWB2mD
         HThY/3lKCrJi6v8OrFeJG7QCuj8CiyfdUbgaTPd7yLRjWtYXXIwj+L0Ake67XwREVlIK
         r80lALzt7yiCNUnCfQLerQ6ZEjbujE/oXHJTk=
Subject: Re: [PATCH-ugly] kmemtrace: casting a gfp_t requires __force
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Eduard Munteanu <eduard.munteanu@linux360.ro>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081107192029.GA4001@x200.localdomain>
References: <1226084321.11596.37.camel@brick>
	 <20081107192029.GA4001@x200.localdomain>
Content-Type: text/plain
Date: Fri, 07 Nov 2008 11:22:39 -0800
Message-Id: <1226085759.11596.43.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-07 at 22:20 +0300, Alexey Dobriyan wrote:
> On Fri, Nov 07, 2008 at 10:58:41AM -0800, Harvey Harrison wrote:
> > --- a/include/linux/kmemtrace.h
> > +++ b/include/linux/kmemtrace.h
> > @@ -34,7 +34,7 @@ static inline void kmemtrace_mark_alloc_node(enum kmemtrace_type_id type_id,
> >  		   "bytes_req %lu bytes_alloc %lu gfp_flags %lu node %d",
> >  		   type_id, call_site, (unsigned long) ptr,
> >  		   (unsigned long) bytes_req, (unsigned long) bytes_alloc,
> > -		   (unsigned long) gfp_flags, node);
> > +		   (__force unsigned long)gfp_flags, node);
> 
> gfp_t is "unsigned int" actually. These casts are bogus.
> 
> Subject: How do I printk <type> correctly?
> 
> If variable is of Type	use	printk format specifier.
> ---------------------------------------------------------
> 		int			%d or %x
> 		unsigned int		%u or %x
> 		long			%ld ot %lx
> 		unsigned long		%lu or %lx
> 		long long		%lld or %llx
> 		unsigned long long	%llu or %llx
> 		size_t			%zu or %zx
> 		ssize_t			%zd or %zx
> 

Perhaps add gfp_t to the list ;-)

Thanks.

Harvey

