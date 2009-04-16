Return-Path: <linux-kernel-owner+w=401wt.eu-S1757347AbZDPP3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347AbZDPP3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 11:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbZDPP3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 11:29:22 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:50269 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbZDPP3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 11:29:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MkyDvaLgT549s+azTrOmyBZ0aX1MF2ErniQ2oLeUkGS5Fp6B+b+gfSNSquInXNafFI
         Kdvt5Eqe5IPFCfB5YlKtsIQz2bZxIhS+SMNWVu9IWUEWd8B08Zzq2Siim3xSnwKl3Rhg
         EhZQ/87/EmS1Lu7Nmh6U8KWxrZCc2Ue642F5A=
Date: Thu, 16 Apr 2009 17:29:17 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] tracing/filters: allow on-the-fly filter switching
Message-ID: <20090416152916.GA6004@nowhere>
References: <1239610670.6660.49.camel@tropicana> <20090414205635.GA5968@nowhere> <1239769945.7852.21.camel@tropicana> <20090415162151.GH5989@nowhere> <49E681B5.8070505@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E681B5.8070505@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 08:54:13AM +0800, Li Zefan wrote:
> Frederic Weisbecker wrote:
> >>> Also, is filter_add_pred() supposed to be available for in-kernel
> >>> uses by other tracers or something?
> >> No, the current callers were the only ones I'd planned on (it's not
> >> static because code in trace_events.c needs to call it).  But, do you
> >> see a use for it by other tracers?
> > 
> > 
> > 
> > May be in the future, it's possible that a tracer might want to
> > set filters by itself.
> > But I don't think it has to be fixed now because there are nothing
> > like that for now.
> > 
> > So, no problem :-)
> > 
> 
> If we restricted the mutex in trace_events_filters.c only, all the
> extern functions can be called without lock, and this is what I did
> in my previous patch.


Indeed, sounds better.

 
> >  
> >>> If this is planned, the locking could be even deeper than my comments.
> 

