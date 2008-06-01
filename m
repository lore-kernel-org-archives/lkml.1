Return-Path: <linux-kernel-owner+w=401wt.eu-S1756025AbYFAK0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbYFAK0S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 06:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbYFAK0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 06:26:11 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:48953 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751569AbYFAK0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 06:26:10 -0400
Date: Sun, 1 Jun 2008 19:24:01 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: David Howells <dhowells@redhat.com>, Christoph Lameter <clameter@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, cooloney@kernel.org,
       akpm@linux-foundation.org, mpm@selenic.com
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
Message-ID: <20080601102401.GD25429@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Pekka J Enberg <penberg@cs.helsinki.fi>,
	David Howells <dhowells@redhat.com>,
	Christoph Lameter <clameter@sgi.com>,
	LKML <linux-kernel@vger.kernel.org>, cooloney@kernel.org,
	akpm@linux-foundation.org, mpm@selenic.com
References: <483DBA85.2060502@cs.helsinki.fi> <Pine.LNX.4.64.0805281325260.932@schroedinger.engr.sgi.com> <483DBFC3.1070108@cs.helsinki.fi> <29611.1212066517@redhat.com> <Pine.LNX.4.64.0805291620250.5415@sbz-30.cs.helsinki.fi> <20080529211207.GB13663@linux-sh.org> <484256AA.3000709@cs.helsinki.fi> <Pine.LNX.4.64.0806011119420.11749@sbz-30.cs.Helsinki.FI> <20080601082427.GC25429@linux-sh.org> <Pine.LNX.4.64.0806011208480.13090@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806011208480.13090@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2008 at 12:13:02PM +0300, Pekka J Enberg wrote:
> Hi Paul,
> 
> On Sun, 1 Jun 2008, Paul Mundt wrote:
> > This still needs to be virt_to_head_page() I think.
> > 
> > I don't have my nommu boards at home, so I'll test at the office tomorow
> > morning and let you know.
> 
> I was about to send a patch that fixes some of the kobjsize() abuses to 
> use ksize() but then I realized that what we probably should do is 
> something like this instead.
> 
> I mean, assuming the BUG_ON bits are bogus, then we should always pass the 
> pointer to the allocator. I audited most of the callers and they all seem 
> to be really just using kmalloc() for allocation anyway.
> 
> What do you think?
> 
Isn't this what my original patch did? ;-)
