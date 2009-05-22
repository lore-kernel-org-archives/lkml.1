Return-Path: <linux-kernel-owner+w=401wt.eu-S1752472AbZEVF1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbZEVF1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 01:27:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbZEVF0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 01:26:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42624 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbZEVF0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 01:26:53 -0400
Date: Fri, 22 May 2009 06:26:52 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
       Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, Len Brown <len.brown@intel.com>,
       Mike Travis <travis@sgi.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH V2 0/3] Introduce and use DO_ONCE statement expression
	macro
Message-ID: <20090522052652.GX8633@ZenIV.linux.org.uk>
References: <cover.1242965306.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1242965306.git.joe@perches.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 21, 2009 at 09:27:29PM -0700, Joe Perches wrote:
> The printk_once macro in kernel.h is limited to printk
> 
> This generalizes the functionality of printk_once and
> allows statements like DO_ONCE(pr_info("foo\n"))
> and DO_ONCE(initialize(foo));

Sigh...  Please, don't do introduce new control structures without extremely
good reasons.

printk_once() has syntax of function call; it's far more tolerable for
casual reader (e.g. somebody looking through the code while trying to
localize a bug) since it doesn't interrupt the flow - it parses as
"some function call, apparently doing some debugging output, let's see
if there are any obvious side effects in the arguments and move on".
Your DO_ONCE(....) parses as "what the fuck is that?" followed by
grepping for definition, and the cost is much higher.

Don't do that.  Staying close to normal syntax is a very good thing;
preprocessor can be used in a lot of ways that are harmful and introduction
of (effectively) new kinds of statements is a prime example.  It *does*
have its place, but it should be done very sparingly.
