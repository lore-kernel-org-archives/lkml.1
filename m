Return-Path: <linux-kernel-owner+w=401wt.eu-S1751980AbXCUIhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbXCUIhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 04:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbXCUIhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 04:37:51 -0400
Received: from saeurebad.de ([85.214.36.134]:35095 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980AbXCUIhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 04:37:50 -0400
Date: Wed, 21 Mar 2007 09:37:36 +0100
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: Wink Saville <wink@saville.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] Initial implementation of the trec driver and include files
Message-ID: <20070321083736.GB16768@leiferikson>
Mail-Followup-To: Wink Saville <wink@saville.com>,
	linux-kernel@vger.kernel.org
References: <d4cf37a60703202347o67740694jc1c9030c647ff7c6@mail.gmail.com> <20070321082238.GA16768@leiferikson>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070321082238.GA16768@leiferikson>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Mar 21, 2007 at 09:22:39AM +0100, Johannes Weiner wrote:
> Your patch has broken lines where there shouldn't be any.

I mean, the attached patch. This is probably not an error in the patch
but in the way of posting it.

> > +static int snprint_address(char *b, int bsize, unsigned long address)
> > +{
> > +#ifdef CONFIG_KALLSYMS
> > +	unsigned long offset = 0, symsize;
> > +	const char *symname;
> > +	char *modname;
> > +	char *delim = ":";
> > +	int n;
> > +	char namebuf[128];
> > +
> > +	symname = kallsyms_lookup(address, &symsize, &offset, &modname, 
> > namebuf);
> > +	if (!symname) {
> > +		n = 0;
> > +	} else {
> > +		if (!modname)
> > +			modname = delim = ""; 		
> > +		n = snprintf(b, bsize, "0x%016lx %s%s%s%s+0x%lx/0x%lx",
> > +			address, delim, modname, delim, symname, offset, 
> > symsize);
> > +	}
> > +	return n;
> > +#else
> > +	return snprintf(b, bsize, "0x%016lx", address);
> > +	return 0;
> > +#endif
> > +}
> 
> Would it make sense to #ifdef the whole function?
> Make it static int (*)(...) if CONFIG_KALLSYMS and otherwise just a
> static inline int (*)(...) { return 0; }

Sorry, I meant:

[...]
#else /* !CONFIG_KALLSYMS */
static inline int snprint_address(char *b, int bsize, unsigned long addr)
{
	return snprintf(b, bsize, "%#16x", addr);
}
#endif

=Hannes
