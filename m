Return-Path: <linux-kernel-owner+w=401wt.eu-S1753270AbZHEWrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbZHEWrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 18:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbZHEWrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 18:47:14 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:56325 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbZHEWrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 18:47:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZBcqz7vfh0f/MgZrpWzSN4MwW3vhS6d6bidpBKxhedKdHaJZYquJfx29CbzlTuuZ3a
         LyIkJJwky7MKo9BHxoETSVdF8FT61p5IhgEfrziR4FzoZdGoWZrv2cbSyDrIXDxg0pCz
         57DFNoXke/wsO1spXatrEb1DcTpWAoTLpj9/c=
Date: Thu, 6 Aug 2009 00:47:11 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH 4/5] tracing/filters: Provide basic regex support
Message-ID: <20090805224709.GH5025@nowhere>
References: <1249111408-8657-1-git-send-email-fweisbec@gmail.com> <1249111408-8657-5-git-send-email-fweisbec@gmail.com> <4A76782E.4030803@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A76782E.4030803@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 01:39:58PM +0800, Li Zefan wrote:
> Frederic Weisbecker wrote:
> > This patch provides basic support for regular expressions in filters.
> > The common filter file doesn't support any regex but a new
> > filter_regex file is created for each subsystem/event.
> > 
> > It supports the following types of regexp:
> > 
> > - *match_beginning
> > - *match_middle*
> > - match_end*
> > - !don't match
> > 
> 
> I don't see why adding "filter_regex" is necessary, why not just make
> "filter" support regex?


I did that because I feared about people beeing unable to filter using
* as a real character inside a filter string.
If we are using only one file, we are forced to get the '*' interpreted.
That would also break the ABI.



> > Every string is now handled as a regexp in the filter framework, which
> > helps to factorize the code for handling both simple strings and
> > regexp comparisons.
> > 
> > (The regexp code has been savagely cherry picked from ftrace.c
> > writtent by Steve. If this patch makes its way, I'll be happy
> > to change ftrace to use the new filter helpers)

