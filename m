Return-Path: <linux-kernel-owner+w=401wt.eu-S1761238AbXIYAbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761238AbXIYAbu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 20:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbXIYAbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 20:31:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365AbXIYAbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 20:31:40 -0400
Date: Mon, 24 Sep 2007 20:31:27 -0400
From: Dave Jones <davej@redhat.com>
To: roel <12o3l@tiscali.nl>
Cc: travis@sgi.com, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       Jack Steiner <steiner@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86: Convert cpuinfo_x86 array to a per_cpu array
	v3
Message-ID: <20070925003127.GQ11455@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, roel <12o3l@tiscali.nl>,
	travis@sgi.com, Andrew Morton <akpm@linux-foundation.org>,
	Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
	Jack Steiner <steiner@sgi.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
References: <20070924210853.256462000@sgi.com> <20070924210853.516791000@sgi.com> <46F833D4.8050507@tiscali.nl> <20070924232423.GJ8127@redhat.com> <46F85431.1020306@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F85431.1020306@tiscali.nl>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2007 at 02:20:01AM +0200, roel wrote:
 
 > >  > >  	if ((c->x86_vendor != X86_VENDOR_AMD) || (c->x86 != 5) ||
 > >  > >  		((c->x86_model != 12) && (c->x86_model != 13)))
 > >  > 
 > >  > while we're at it, we could change this to
 > >  > 
 > >  >   	if (!(c->x86_vendor == X86_VENDOR_AMD && c->x86 == 5 &&
 > >  >   		(c->x86_model == 12 || c->x86_model == 13)))
 > > 
 > > For what purpose?  There's nothing wrong with the code as it stands,
 > > and inverting the tests means we'd have to move a bunch of
 > > code inside the if arm instead of just returning -ENODEV.
 > 
 > It's not inverting the test, so you don't need to move code. It evaluates 
 > the same, only the combined negation is moved to the front. I suggested it
 > to increase clarity, it results in the same assembly language.

I don't see it as being particularly more readable after this change.
In fact, the reverse, as my previous comment implied, I missed the
initial !
Given this code works fine, and there's no discernable gain from
changing it, I'm not particularly enthusiastic about this modification.

	Dave

-- 
http://www.codemonkey.org.uk
