Return-Path: <linux-kernel-owner+w=401wt.eu-S937517AbXHHSBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937517AbXHHSBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 14:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759704AbXHHSBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 14:01:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005AbXHHSBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 14:01:24 -0400
Date: Wed, 8 Aug 2007 14:00:56 -0400
From: Dave Jones <davej@redhat.com>
To: jschopp <jschopp@austin.ibm.com>
Cc: apw@shadowen.org, rdunlap@xenotime.net,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Make checkpatch warn about pointless casting of kalloc returns.
Message-ID: <20070808180056.GF26440@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	jschopp <jschopp@austin.ibm.com>, apw@shadowen.org,
	rdunlap@xenotime.net, Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070808024321.GA6316@redhat.com> <46B9F7C9.9060406@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B9F7C9.9060406@austin.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2007 at 12:05:13PM -0500, jschopp wrote:
 > > +# check for pointless casting of kmalloc return
 > > +		if ($rawline =~ /\*\)[ ]k[czm]alloc/) {
 > 
 > It looks to me like this will catch
 > 
 > foo = (char *) kmalloc(512);
 > 
 > but not
 > 
 > for = (char* )kmalloc(512);
 > 
 > I haven't tried it but how about something like:
 > 
 > if($rawline =~/\(.*\)\s*k[czm]alloc/){

Hmm,  could even just drop the check for the '*'
)[ ]k.. should be good enough.

 > which if I got it right should match the typecast with any combination of spacing.
 > 
 > > +			WARN("No need to cast return value.\n");
 > 
 > Could the warning be more descriptive?  This describes what, but it should also describe 
 > why; after all if somebody made this error they may not know they why.

I'm open to suggestions..

	Dave

-- 
http://www.codemonkey.org.uk
