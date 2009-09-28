Return-Path: <linux-kernel-owner+w=401wt.eu-S1752570AbZI1Ism@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbZI1Ism (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 04:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbZI1Isl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 04:48:41 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:61719 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbZI1Isk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 04:48:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VTPDjNbNoPuwyIBLC+sghLlWmyJjj9BKIUJOJy1CQVGVDPD+HErm3ToI1w3rLwR/Ya
         5KX0QfAFkx8juYoWDy3FkocFfQczkFiQRo+EaZi/HhuWTbbZf1RlStXy1XWBUjuVY3lM
         KSPyTAGWueAwibjpjX04qoKw0J3TLvEHFrMkg=
Date: Mon, 28 Sep 2009 10:48:38 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       lizf@cn.fujitsu.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/core] tracing/bkl: Add bkl ftrace events
Message-ID: <20090928084836.GA6142@nowhere>
References: <tip-96a2c464de07d7c72988db851c029b204fc59108@git.kernel.org> <1253959554.12145.88.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253959554.12145.88.camel@frodo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 26, 2009 at 06:05:54AM -0400, Steven Rostedt wrote:
> On Fri, 2009-09-25 at 06:19 +0000, tip-bot for Frederic Weisbecker
> wrote:
> > Commit-ID:  96a2c464de07d7c72988db851c029b204fc59108
> 
> > +#if !defined(_TRACE_BKL_H) || defined(TRACE_HEADER_MULTI_READ)
> > +#define _TRACE_BKL_H
> > +
> > +#include <linux/tracepoint.h>
> > +
> > +TRACE_EVENT(lock_kernel,
> > +
> > +	TP_PROTO(const char *func, const char *file, int line),
> > +
> > +	TP_ARGS(func, file, line),
> > +
> > +	TP_STRUCT__entry(
> > +		__field(	int,		lock_depth		)
> 
> FYI,
> 
> By your request I added this as a common field ;-)
> 
> With commit:
> 
>  637e7e864103a7a68c1ce43ada27dfc25c0d113f
> 
> But since other utilities outside of ftrace may use this trace point, it
> may be OK to keep the duplicate information in the kernel lock API trace
> points.
> 
> -- Steve




Right, or may be we can define this tracepoint as a latency format
user by default. It's not possible yet for an event to do that but
I guess we can set a flag for this purpose or something...

Thanks.

