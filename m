Return-Path: <linux-kernel-owner+w=401wt.eu-S1756913AbZHGCyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913AbZHGCyI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 22:54:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755409AbZHGCyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 22:54:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50575 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbZHGCyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 22:54:07 -0400
Date: Thu, 6 Aug 2009 22:54:06 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <f.weisbecker@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tracing/filters: Support filtering for char *
 strings
In-Reply-To: <4A7B8149.3070901@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0908062251230.2840@gandalf.stny.rr.com>
References: <4A7A72BD.5030201@cn.fujitsu.com> <4A7A72FA.9040102@cn.fujitsu.com> <alpine.DEB.2.00.0908061020240.9870@gandalf.stny.rr.com> <4A7B8149.3070901@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 7 Aug 2009, Li Zefan wrote:

> >>  	if (is_string_field(field)) {
> >> +		pred->str_len = field->size;
> >> +
> >>  		if (field->filter_type == FILTER_STATIC_STRING)
> >>  			fn = filter_pred_string;
> >> -		else
> >> +		else if (field->filter_type == FILTER_DYN_STRING)
> >>  			fn = filter_pred_strloc;
> >> -		pred->str_len = field->size;
> >> +		else {
> >> +			fn = filter_pred_pchar;
> >> +			pred->str_len = strlen(pred->str_val);
> >> +		}
> > 
> > I'm a little dense here, where do we protect against someone making a 
> > tracepoint that points to unsafe data?
> > 
> 
> We can't prevent anyone from doing insane things deliberately, but
> we prevent from doing wrong things unconsciously.
> 
> Only if a TRACE_EVENT has a field defined as:
> 
> 	__field_ext(char *, name, FILTER_PTR_STR)
> 
> Here using FILTER_PTR_STR explicitly, he should know what he's doing.
> 
> Anyway, he can make a ptr pointing to unsafe data this way:
> 
> 	TP_STRUCT__entry(
> 		__field(char *, name)
> 	)
> 	TP_printk("%s", name)

I guess the thing I'm missing is what's the difference of the two? Why 
would a developer use __field_ext instead of doing it the unsafe way of 
just __field?

I guess I don't see the developer doing something wrong unconsciously. 
Well maybe I don't see this making the developer do it right 
unconsciously.

What protection is this giving us?

-- Steve

