Return-Path: <linux-kernel-owner+w=401wt.eu-S1752686AbZH0NfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbZH0NfH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 09:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbZH0NfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 09:35:06 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:38947 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbZH0NfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 09:35:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AkXX5Qdo3Z9C3R4UVDr3Nl9qP1B3Gc0IqJKuWTsQrQblSTMurQCFyNLH9DURGBZiQK
         8xTHvsz0eliwmpvmD/DHcCag3iUxPxhGBQit79A4MdPN97T6zBktdjm28iQopNmamo9l
         BapdgUGxWpr4O7khOZJ8ERzBi+NNSvfMC6MV8=
Date: Thu, 27 Aug 2009 15:35:02 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: remove PERF_SAMPLE_RAW
Message-ID: <20090827133455.GB6058@nowhere>
References: <1251361073.18584.46.camel@twins> <20090827084321.GD2131@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090827084321.GD2131@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 10:43:21AM +0200, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > Apparently people think trace-events became an ABI the moment perf 
> > exported them, regardless what the text surrounding 
> > PERF_SAMPLE_RAW said about the opaqueness of the data provided.
> 
> Well it's still opaque and the descriptor of what it means is in 
> debugfs so it's not an ABI as the comment says.
> 
> > I'm not willing to make anything trace related into an ABI, hence 
> > remove this.
> 
> This removes quite a bit of nice functionality we already have, so i 
> think it's (way) too heavy handed.
> 
> I think what we want is the golden middle: a per tracepoint 
> property. I.e. we would provide:
> 
>     TRACE_EVENT_STABLE()
> 
> or TRACE_EVENT_CORE() or TRACE_EVENT_ABI() - which carries a 'will 
> maintain this as an ABI' promise from the maintainer who adds it.


Why? The format files stand to avoid that.

I don't understand this debate.


> Also, tracepoints are a unidirectional channel of information - in 
> practice those are way easier to handle as an ABI than other ABIs 
> such as behavior, semantics, etc. So i'd expect there to be a 
> healthy set of 'stable' tracepoints.
> 
> 	Ingo

