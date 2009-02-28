Return-Path: <linux-kernel-owner+w=401wt.eu-S1754526AbZB1RSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbZB1RSy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 12:18:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbZB1RSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 12:18:46 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:58338 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbZB1RSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 12:18:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=C69V9kqu1JWmuSFppec43SuElIIlf2H4WFx+LoBnC8yw6LehJOKUgQccIWFylPPOuq
         +CpE1NGcadzoRtUSpINRXslVf0XMU7K5htvBM2cpHgXINZwbEPOEhtVzMvEAK/fkO2fH
         fceUEhzqcBHVNeHA+ElEYyDbQwbWhMLMIZih0=
Date: Sat, 28 Feb 2009 18:18:39 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH][RFC] vsprintf: unify the format decoding layer for its
	3 users
Message-ID: <20090228171838.GA5821@nowhere>
References: <20090226174303.GC29439@elte.hu> <20090226174547.GC5889@nowhere> <20090226175225.GA4527@elte.hu> <20090226183415.GE5889@nowhere> <20090226185208.GA6658@nowhere> <20090226185635.GA12895@elte.hu> <20090227061936.GA5318@nowhere> <alpine.LFD.2.00.0902271631231.3111@localhost.localdomain> <20090228081123.GA5906@nowhere> <alpine.LFD.2.00.0902280845580.3111@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902280845580.3111@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 28, 2009 at 08:54:15AM -0800, Linus Torvalds wrote:
> 
> 
> On Sat, 28 Feb 2009, Frederic Weisbecker wrote:
> > 
> > You're right, that's much proper.
> > See the V2 below:
> 
> Good. This looks better.
> 
> One final (?) nit:
> 
> > +		default: {
> > +			enum format_type type = spec.type;
> > +
> > +			if (type == FORMAT_TYPE_LONG_LONG)
> > +				num = va_arg(args, long long);
> > +			else if (type == FORMAT_TYPE_ULONG)
> > +				num = va_arg(args, unsigned long);
> > +			else if (type == FORMAT_TYPE_LONG)
> > +				num = va_arg(args, unsigned long);
> > +			else if (type == FORMAT_TYPE_SIZE_T)
> > +				num = va_arg(args, size_t);
> > +			else if (type == FORMAT_TYPE_PTRDIFF)
> > +				num = va_arg(args, ptrdiff_t);
> > +			else if (type == FORMAT_TYPE_USHORT)
> > +				num = (unsigned short) va_arg(args, int);
> > +			else if (type == FORMAT_TYPE_SHORT)
> > +				num = (short) va_arg(args, int);
> > +			else if (type == FORMAT_TYPE_UINT)
> > +				num = va_arg(args, unsigned int);
> > +			else
> > +				num = va_arg(args, unsigned int);
> > +
> > +			str = number(str, end, num, spec.base,
> > +				spec.field_width, spec.precision, spec.flags);
> 
> You've got three copes of these (in the three different users), and that 
> just looks horrid. I see why you did it, but even something like
> 
> 		case FORMAT_TYPE_LONG_LONG:
> 			num = va_arg(args, long long);
> 			goto handle_number;
> 		case FORMAT_TYPE_ULONG:
> 		...
> 		case FORMAT_TYPE_INT:
> 			num = va_arg(args, int);
> 	handle_number:
> 		str = number(str, end, num, &spec);
> 		break;
> 
> would be better.
> 
> And yes, please do pass in "spec" to the "number()/pointer()/string()" 
> routines instead of exploding it into the individual numbers. When 
> cleaning up, let's just do it properly..
> 
> 		Linus


Ok, I'm addressing your comments and those from Ingo, then I will rebase
the whole patchset (with the ftrace_bprintk related things) against latest
-tip and resend it.

Thanks!

