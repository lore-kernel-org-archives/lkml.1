Return-Path: <linux-kernel-owner+w=401wt.eu-S934399AbZLPBW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934399AbZLPBW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 20:22:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756152AbZLPBW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 20:22:27 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:9151 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756116AbZLPBWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 20:22:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Gn74RPw9JeaxGmZJKZEsOab6/o8lmKBK+ZfGL/u9ooQbczS2bR/gBDZqRyWRzRa9/b
         qd3kCERMrHtqHGnterr2kfT9vaemTUbYVJf9iGybNy9FPfIwSt5AXz94gifHwQ2UpwgQ
         TX2RIXpOCLGSHOFi41Fn5YPCbtb2v073wsIpg=
Date: Wed, 16 Dec 2009 02:22:21 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] perf_event: fix getting point
Message-ID: <20091216012219.GD8423@nowhere>
References: <4B27702F.1080507@cn.fujitsu.com> <4B2770AD.90005@cn.fujitsu.com> <4B2770FA.7090803@cn.fujitsu.com> <20091215135855.GA5833@nowhere> <4B2831F3.1040001@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B2831F3.1040001@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 09:03:47AM +0800, Xiao Guangrong wrote:
> >> @@ -1919,13 +1919,32 @@ raw_field_value(struct event *event, const char *name, void *data)
> >>  
> >>  void *raw_field_ptr(struct event *event, const char *name, void *data)
> >>  {
> >> +	void *ptr;
> >> +	unsigned long long value;
> >> +
> >> +	value = raw_field_value(event, name, data);
> >> +
> >> +	if (!value)
> >> +		return NULL;
> >> +
> >> +	memcpy(&ptr, &value, sizeof(ptr));
> > 
> > 
> > 
> > Could you perhaps just do
> > 
> > ptr = (void *)value; ?
> > 
> 
> We can't do it in x86_32:
> error: cast to pointer from integer of different size


You can just do:

ptr = (void *)(unsigned long)value;

