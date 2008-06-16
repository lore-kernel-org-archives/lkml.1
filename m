Return-Path: <linux-kernel-owner+w=401wt.eu-S1756679AbYFPSUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbYFPSUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 14:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbYFPSUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 14:20:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbYFPSUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 14:20:39 -0400
Date: Mon, 16 Jun 2008 14:19:21 -0400
From: "'Jason Baron'" <jbaron@redhat.com>
To: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, joe@perches.com,
       greg@kroah.com, nick@nick-andrew.net, randy.dunlap@oracle.com,
       mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH 0/8] dynamic debug
Message-ID: <20080616181920.GA30284@redhat.com>
References: <20080613185733.GA8813@redhat.com> <009201c8cf58$58909080$09b1b180$@css.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <009201c8cf58$58909080$09b1b180$@css.fujitsu.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 11:26:12AM +0900, Takashi Nishiie wrote:
> Jason Baron wrote:
> >Each kernel sub-system seems to have its own way of dealing with 
> >debugging statements. Some of these methods include 'dprintk', 
> >'pr_debug', 'dev_debug', 'DEBUGP'. There are also a myriad of 
> >ways of enabling these statements. 
> 
>  I propose to replace 'Pr_debug', 'Dev_debug', and 'DEBUGP' with 
> kernel markers. SystemTap is used for the output of the log.  
> 
>  I propose to make it to the function to output only specified 
> kernel markers as a log and the function in a word like LTTng of
> a simple version by using the framework and kernel markers of 
> ftrace if the log is output by using debugfs. 
> 
> Thank you,
> 

perhaps markers could be used to replace 'pr_debug', 'dev_debug', and 'DEBUGP'
but i have yet to see patches for that...

In a number of ways, these dynamic debug patches differ from markers:

-Markers have a pre-defined format string and arguments list, whereas debug
statements have a 'printk' format
-these patches are built around per-module debugging, which is largely implicit
whereas markers explicitly define sets of related markers.
-these patches allow 'flags' and levels to be set per-module, markers do not 
have this concept.
-these patches are tied into a procfs control file, whereas markers are
controlled by kernel modules which register handlers.

These two patchsets are really addressing different problems afaict.

thanks,

-Jason



