Return-Path: <linux-kernel-owner+w=401wt.eu-S1756162AbZCRGMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbZCRGMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 02:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753681AbZCRGMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 02:12:10 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:54866 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064AbZCRGMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 02:12:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nXkxy3Wad+4e7/3sgoWbO77PtXpo8gdllahYLjnbO2wpKvXG20g+9Z/sIQrIpS8Sgl
         BqbnF+Y6Gpgmmh4NnLW5NFQHfZsqohCmf7aqdjYIC1PuL68t/U1CpUVJyItJjOmBh2vy
         QFb5vJ8J1mNZUejSnK6F1KRiKYmOelZDnv3XA=
Subject: Re: [RFC][PATCH 2/4] tracing: add rb_event_discard() hack
From: Tom Zanussi <tzanussi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
In-Reply-To: <alpine.DEB.2.00.0903172108160.10610@gandalf.stny.rr.com>
References: <1237271018.8033.150.camel@charm-linux>
	 <alpine.DEB.2.00.0903172108160.10610@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Wed, 18 Mar 2009 01:12:05 -0500
Message-Id: <1237356725.7922.16.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2009-03-17 at 21:21 -0400, Steven Rostedt wrote:
> On Tue, 17 Mar 2009, Tom Zanussi wrote:

> >  
> >  	rb_update_read_stamp(cpu_buffer, event);
> > @@ -2026,8 +2051,8 @@ rb_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
> >  	 * can have.  Nesting 10 deep of interrupts is clearly
> >  	 * an anomaly.
> >  	 */
> > -	if (RB_WARN_ON(cpu_buffer, ++nr_loops > 10))
> > -		return NULL;
> > +//	if (RB_WARN_ON(cpu_buffer, ++nr_loops > 10))
> > +//		return NULL;
> 
> Were you hitting this? If so, we need to investigate.
> 

I was hitting this, but only because my code would always loop around to
'again' for a discarded event.  So, 10 discarded events in a row would
trigger it.

I noticed that your fix returns instead, so it's no longer a problem.

Thanks,

Tom



