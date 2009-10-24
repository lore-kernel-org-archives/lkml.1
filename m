Return-Path: <linux-kernel-owner+w=401wt.eu-S1753368AbZJXBJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbZJXBJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 21:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbZJXBJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 21:09:12 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:33078 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbZJXBJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 21:09:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ooEHFAtngwf3P51OYOQIo4qQB6Y+m6/Yq5iLfVf9ugZtckw+sOscCk3hTpeOioV/3W
         v3KZEb697bFhDIN80uwo/XEeFlYyxTlB5W+KyKxynhlEgiJl4ppUd+tVT1d5tBqOLBhm
         5+nRqOz5WAmJ6gAci/Agtzbwwq033kMjyVWBM=
Date: Sat, 24 Oct 2009 03:09:09 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Steven Rostedt <rostedt@goodmis.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Robin Getz <rgetz@analog.com>, Dave Young <hidave.darkstar@gmail.com>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/8] SGI x86_64 UV: Add limit console output function
Message-ID: <20091024010906.GA4938@nowhere>
References: <20091023233743.439628000@alcatraz.americas.sgi.com> <20091023233746.128967000@alcatraz.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091023233746.128967000@alcatraz.americas.sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 23, 2009 at 06:37:44PM -0500, Mike Travis wrote:
> With a large number of processors in a system there is an excessive amount
> of messages sent to the system console.  It's estimated that with 4096
> processors in a system, and the console baudrate set to 56K, the startup
> messages will take about 84 minutes to clear the serial port.
> 
> This patch adds (for SGI UV only) a kernel start option "limit_console_
> output" (or 'lco' for short), which when set provides the ability to
> temporarily reduce the console loglevel during system startup.  This allows
> informative messages to still be seen on the console without producing
> excessive amounts of repetious messages.
> 
> Note that all the messages are still available in the kernel log buffer.



Well, this problem does not only concerns SGI UV but all boxes with a large
number of cpus.

Also, instead of adding the same conditionals in multiple places to solve
the same problem (and that may even expand if we go further the SGI UV case,
for example with other archs cpu up/down events), may be can you centralize,
institutionalize this issue by using the existing printk mechanisms.

I mean, may be that could be addressed by adding a new printk
level flag, and then associate the desired filters against it.

KERN_CPU could be a name, since this is targetting cpu events.


