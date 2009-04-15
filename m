Return-Path: <linux-kernel-owner+w=401wt.eu-S1756288AbZDOAOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288AbZDOAOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 20:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbZDOAN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 20:13:59 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:4386 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbZDOAN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 20:13:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iQ/Y+UrLPN+mZL63trPFOqu9yGA2ztvg1AO8SIiRJ1558aBPBy3FZcQL17E5iraIuX
         m9XXcrDbnOorr6quFVi8A12KfChmifuX+4TMMshe1fP7HQ5gFBPEQ8AdpvmxhC2ZDrB6
         zKoGalvEZvb5AqP2Ubd70s9tZ7tZkxXzYUDw4=
Date: Wed, 15 Apr 2009 02:13:54 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vsprintf: introduce %pf
Message-ID: <20090415001353.GH5968@nowhere>
References: <1239753659-11790-1-git-send-email-fweisbec@gmail.com> <1239754196.28331.1.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239754196.28331.1.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 05:09:56PM -0700, Joe Perches wrote:
> On Wed, 2009-04-15 at 02:00 +0200, Frederic Weisbecker wrote:
> > diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> > index b56f6d0..15c9094 100644
> > --- a/lib/vsprintf.c
> > +++ b/lib/vsprintf.c
> > @@ -575,12 +575,15 @@ static char *string(char *buf, char *end, char *s, struct printf_spec spec)
> >  }
> >  
> >  static char *symbol_string(char *buf, char *end, void *ptr,
> > -				struct printf_spec spec)
> > +				struct printf_spec spec, char ext)
> >  {
> >  	unsigned long value = (unsigned long) ptr;
> >  #ifdef CONFIG_KALLSYMS
> >  	char sym[KSYM_SYMBOL_LEN];
> > -	sprint_symbol(sym, value);
> > +	if (ext != 'f')
> > +		sprint_symbol(sym, value);
> > +	else
> > +		kallsyms_lookup(value, NULL, NULL, NULL, sym);
> 
> buffer overflow waiting to happen yes?


But a symbol is not supposed to exceed KSYM_SYMBOL_LEN. 

