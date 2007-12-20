Return-Path: <linux-kernel-owner+w=401wt.eu-S936604AbXLTQbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936604AbXLTQbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 11:31:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761665AbXLTQbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 11:31:36 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:4523 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759854AbXLTQbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 11:31:35 -0500
Date: Thu, 20 Dec 2007 16:29:23 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Joe Perches <joe@perches.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, trivial@kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>
Subject: Re: Trailing periods in kernel messages
Message-ID: <20071220162923.GB27885@shadowen.org>
References: <474E6BD0.20103@cn.fujitsu.com> <E1IxfE8-0000Sr-9w@faramir.fjphome.nl> <474E8669.6060409@cn.fujitsu.com> <200711291120.19595.elendil@planet.nl> <20071129032036.4c021617.akpm@linux-foundation.org> <474F6372.70705@cn.fujitsu.com> <1196386259.22120.101.camel@localhost> <474F6D4D.9010006@cn.fujitsu.com> <1196390128.22120.118.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196390128.22120.118.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 06:35:28PM -0800, Joe Perches wrote:
> On Fri, 2007-11-30 at 09:54 +0800, Li Zefan wrote:
> > So it doesn't deserve the effort to eliminate these periods, isn't it?
> 
> I hope these will eventually disappear.
> 
> > Or we can add a check to checkpatch.pl to prevent new ones.
> 
> Perhaps that's a good idea.
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index cbb4258..707f84c 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -1390,6 +1390,10 @@ sub process {
>  		if ($line =~ /\*\s*\)\s*k[czm]alloc\b/) {
>  			WARN("unnecessary cast may hide bugs, see http://c-faq.com/malloc/mallocnocast.html\n" . $herecurr);
>  		}
> +
> +		if ($rawline =~ /(print|pr_(emerg|alert|crit|err|warning|notice|info|debug)).*\.\\n\"/) {
> +			WARN("unnecessary period before newline\n" . $herecurr);
> +		}

I missed the context on this one.  So this is checking for periods at
the end of messages for printk's.  We would need something a little
cleverer to ensure we are only checking the contents of the string.  But
eminently doable.

/me plays

Ok, yes this seems ok.  Have added it for 0.13.

-apw
