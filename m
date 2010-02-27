Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965112Ab0B0K0H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 05:26:07 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:59091 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964948Ab0B0K0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 05:26:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LNC0v7+tlv7bIlyG96whFK1lwqW1MxaScMZ+M9po9nEpY3HGfJgVNbuZagsQvI/hkM
         15GXo+cYQHL4uyFBt8fJY+ywa+IocEIsuPoSrIVZu9oxYMITGLiGuqUq9ol8NbR2/O4D
         O2TtqelobrM0P9WWPJnPX7CsBve/XC/vfR6w4=
Date: Sat, 27 Feb 2010 11:25:58 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: "Bird, Tim" <Timothy.Bird@am.sony.com>,
       Steven Rostedt <srostedt@redhat.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] ftrace: add tracing_thresh support to function_graph
	tracer (v3)
Message-ID: <20100227102556.GE5130@nowhere>
References: <4B87098B.4040308@am.sony.com> <20100226024601.GG5592@nowhere> <4B881291.3040903@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B881291.3040903@am.sony.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 10:27:29AM -0800, Tim Bird wrote:
> On 02/25/2010 06:46 PM, Frederic Weisbecker wrote:
> >> +static int __init set_tracing_thresh(char *str)
> >> +{
> >> +	unsigned long threshhold;
> >> +	int ret;
> >> +
> >> +	if (!str)
> >> +		return 0;
> >> +	ret = strict_strtoul(str, 0, &threshhold);
> >> +	if (ret < 0)
> >> +		return 0;
> >> +	tracing_thresh = threshhold * 1000;
> >> +	return 1;
> >> +}
> >> +__setup("tracing_thresh=", set_tracing_thresh);
> > 
> > Looks like setting this, while the function graph tracer (normal
> > mode) is running, will have no effect. That said it's perfectly
> > fine as it would be pointless to change this value in the middle
> > of the tracing.
> > 
> The command line is parsed before the tracer is activated, so
> tracing_thresh is set when trace_graph_init() is called, which
> results in the desired behaviour (that is, if you specify the
> tracing_thresh on the command line, you get the duration
> filtering on bootup).


Oh right, I made a confusion with the tracing_thresh file
write callback.

