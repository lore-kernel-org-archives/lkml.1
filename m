Return-Path: <linux-kernel-owner+w=401wt.eu-S935123AbXEVTlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935123AbXEVTlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 15:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758357AbXEVTlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 15:41:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757233AbXEVTlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 15:41:11 -0400
Date: Tue, 22 May 2007 15:40:30 -0400
From: Dave Jones <davej@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] add "notime" boot option
Message-ID: <20070522194030.GF12157@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	lkml <linux-kernel@vger.kernel.org>,
	akpm <akpm@linux-foundation.org>
References: <20070522120938.db67f1e9.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070522120938.db67f1e9.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 12:09:38PM -0700, Randy Dunlap wrote:
 > --- linux-2622-rc2.orig/kernel/printk.c
 > +++ linux-2622-rc2/kernel/printk.c
 > @@ -458,9 +458,17 @@ static int __init printk_time_setup(char
 >  	printk_time = 1;
 >  	return 1;
 >  }
 > -
 >  __setup("time", printk_time_setup);
 >  
 > +static int __init printk_notime_setup(char *str)
 > +{
 > +	if (*str)
 > +		return 0;
 > +	printk_time = 0;
 > +	return 1;
 > +}
 > +__setup("notime", printk_notime_setup);
 > +
 >  __attribute__((weak)) unsigned long long printk_clock(void)
 >  {
 >  	return sched_clock();

Not disagreeing with the patch, but I wonder if it'd be a net win
if we had a helper that would replace the zillion instances
of "set this variable to a 0/1 depending if its prefixed with 'no'"
with 1-2 lines.

	Dave

-- 
http://www.codemonkey.org.uk
