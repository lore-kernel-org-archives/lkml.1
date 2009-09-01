Return-Path: <linux-kernel-owner+w=401wt.eu-S1755312AbZIAWhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbZIAWhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 18:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755296AbZIAWhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 18:37:04 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:51098 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290AbZIAWhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 18:37:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TXkv7jiyowzEbLXdJUcRtBGOwPqY7x1SKoph7yWE8bqccC4eQGneeszNJXpkTGapVh
         9/QPmISCFEGoLFnhUcNUOYjp09LoknYpB9qrf6QMzTHGNjKo5S12h9tWCgnjMGzpA1Jh
         /8jQctUxvi2XVT2rsv5BgqyVEI6QnpdrmFkao=
Date: Wed, 2 Sep 2009 00:37:01 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] tracing: make splice_read work when data is
	sufficient
Message-ID: <20090901223659.GB6108@nowhere>
References: <4A95F743.2090101@cn.fujitsu.com> <20090829094503.GA6418@nowhere> <4A9D13C1.4030902@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9D13C1.4030902@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 01, 2009 at 08:29:53PM +0800, Lai Jiangshan wrote:
> Frederic Weisbecker wrote:
> >>  	 */
> >> +	cpu_buffer->reader_page->read = 0;
> > 
> > 
> > 
> > Wasn't this reset done before?
> > 
> > 
> 
> This is not reset. It is still used just before this line.



Yeah but after that it's not used anymore because this page
won't anymore be used as a reader page but will be integrated
as a writable ring buffer page.

One day it may be reused as a reader page still, but before
any use, rb_reset_reader_page() will be called to reset this offset.

So I just don't understand why you need to do that.


 
> > 
> > 
> > Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>
> > 
> > 
> 
> Ingo, Could you apply this patch and fix the bug?
> 

