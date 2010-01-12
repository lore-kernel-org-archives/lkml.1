Return-Path: <linux-kernel-owner+w=401wt.eu-S1753266Ab0ALVo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab0ALVo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 16:44:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479Ab0ALVo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 16:44:56 -0500
Received: from www84.your-server.de ([213.133.104.84]:41137 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab0ALVoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 16:44:55 -0500
Subject: Re: [PATCH] checkpatch.pl: add union and struct to the exceptions
 list
From: Stefani Seibold <stefani@seibold.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, apw@canonical.com,
       jschopp@austin.ibm.com, davej@redhat.com
In-Reply-To: <20100111144204.f52568d6.akpm@linux-foundation.org>
References: <1262796360.1011.9.camel@wall-e>
	 <20100111144204.f52568d6.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 12 Jan 2010 22:44:32 +0100
Message-ID: <1263332672.4373.12.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 11.01.2010, 14:42 -0800 schrieb Andrew Morton:
> On Wed, 06 Jan 2010 17:46:00 +0100
> Stefani Seibold <stefani@seibold.net> wrote:
> 
> > This patch add the struct and union keywords to the exceptions list of
> > the checkpatch.pl script, to prevent error message "Macros with multiple
> > statements should be enclosed in a do - while loop". Otherwise it is not
> > possible to build a struct or union with a macro. 
> > 
> > Signed-off-by: Stefani Seibold <stefani@seibold.net>
> > ---
> >  checkpatch.pl |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > --- linux-2.6.33-rc2.orig/scripts/checkpatch.pl	2009-12-03 04:51:21.000000000 +0100
> > +++ linux-2.6.33-rc2.new/scripts/checkpatch.pl	2010-01-06 17:35:29.747634447 +0100
> > @@ -2348,6 +2348,8 @@ sub process {
> >  				DECLARE_PER_CPU|
> >  				DEFINE_PER_CPU|
> >  				__typeof__\(|
> > +				union|
> > +				struct|
> >  				\.$Ident\s*=\s*|
> >  				^\"|\"$
> >  			}x;
> 
> hm.  Perhaps it would help if you could provide a snippet of code which
> triggers the incorrect warning?
> 

Here is a small code snippet, which will be complained by the
checkpatch.pl:

#define __STRUCT_KFIFO_COMMON(recsize, ptrtype) \
	union { \
		struct { \
			unsigned int	in; \
			unsigned int	out; \
		}; \
		char		rectype[recsize]; \
		ptrtype		*ptr; \
		const ptrtype	*ptr_const; \
	};

This construct is legal an save, so checkpatch.pl should accept this. It
should be also true for struct defined in a macro.

Stefani


