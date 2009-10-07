Return-Path: <linux-kernel-owner+w=401wt.eu-S932867AbZJGIVD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932867AbZJGIVD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:21:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932235AbZJGIVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:21:00 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:41831 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117AbZJGIU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:20:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=avZ8Ke+KmEJGYUJiY2WMmOo/ZlIoSev6gMRZB/nNBbN3G81qFvuQmX5SQxwvU2uzNk
         UwkyzwSp9c/8go7LAkg7QF/yLSVGsshlHX8hRMjDhhQ1sZZLt4CtR3N8jYdf9nSd0Ixd
         MYPa65PMI49QccwAUNstmK2fObh0qWchgKyLQ=
Date: Wed, 7 Oct 2009 10:20:22 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] perf tools: Merge trace.info content into
	perf.data
Message-ID: <20091007082020.GC5043@nowhere>
References: <20091006213643.GA5343@nowhere> <1254898050.26976.146.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254898050.26976.146.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 08:47:30AM +0200, Peter Zijlstra wrote:
> On Tue, 2009-10-06 at 23:36 +0200, Frederic Weisbecker wrote:
> > Hi,
> > 
> > Here is an attempt to remove the trace.info file.
> > It works well for me, the reason for it to be an RFC
> > is that I have doubts about the backward compatibility.
> > 
> > A file created by perf after his patch is unsupported
> > by previous version because the size of the headers have
> > increased.
> > 
> > That said, it's two new fields that have been added in
> > the end of the headers, and those could be ignored by
> > previous versions if they just handled the dynamic header
> > size and then ignore the unknow part. The offsets guarantee
> > the compatibility.
> > But previous versions handle the header size using its
> > static size, not dynamic, then it's not backward compatible.
> > 
> > Anyway, I'm not sure exactly how to handle that.
> 
> If we're still able to read 'regular' old perf.data files after this.
> That is, allow to read short headers and assume the tail is 0 we'll be
> good. (this will break trace files that rely on the now removed
> trace.info, but that's unavoidable I guess).
> 
> So backwards compatible, but no fwd compat for the old perf.


Hmm, but forward is possible. It will just ignore the trace.info
part.

