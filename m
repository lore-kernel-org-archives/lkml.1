Return-Path: <linux-kernel-owner+w=401wt.eu-S1761109AbYALSgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761109AbYALSgU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 13:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756402AbYALSgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 13:36:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36982 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755912AbYALSgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 13:36:06 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH/RFC] synchronize_rcu(): high latency on idle system
Date: Sat, 12 Jan 2008 19:35:58 +0100
User-Agent: KMail/1.9.6
Cc: dipankar@in.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <20080112012626.GI28570@kvack.org> <20080112023759.GG21068@bingen.suse.de> <20080112175135.GK28570@kvack.org>
In-Reply-To: <20080112175135.GK28570@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801121935.58286.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 January 2008 18:51:35 Benjamin LaHaise wrote:
> On Sat, Jan 12, 2008 at 03:37:59AM +0100, Andi Kleen wrote:
> > > And yes, the 
> > > network stack shouldn't call synchronize_rcu() quite so much, but fixing that 
> > > is a little more involved.
> > 
> > ... but the correct solution.
> 
> There has to be at least 1 synchronize_rcu() or equivalent in the 
> unregister_netdev() path.  I suspect the easiest way to fix it might be to 
> use call_rcu() to actually free the network device, as anything else will 
> limit performance of single threaded teardown (ie, when an l2tp daemon 
> gets terminated via kill -9).  This means an API change that exposes 
> rcu for unregister_netdev().

The call_rcu() could be in free_netdev() couldn't it?

-Andi
