Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549Ab0A0QBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab0A0QBN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 11:01:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755498Ab0A0QBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 11:01:12 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:48766 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328Ab0A0QBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 11:01:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VI2bcrJam5YrClzNxihzhAjqN4+kUs9b3GP6rFPeDM/LPaoXV/Vc94+ZcnFjZwJIS3
         pqkOhI2WzzS0yBNoJyp5j4hd2r8TuTRJmmqPyB8Va4VksVDZg7F3ZZy0Wq+jI7ShH1+4
         YNKCi2iM+zsLMcFkvDNxdx3H5hCisvi7ES7+8=
Date: Wed, 27 Jan 2010 17:01:06 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Tom Tromey <tromey@redhat.com>,
       Kyle Moffett <kyle@moffetthome.net>,
       "Frank Ch. Eigler" <fche@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>, JimKeniston <jkenisto@us.ibm.com>
Subject: Re: linux-next: add utrace tree
Message-ID: <20100127160103.GB22447@nowhere>
References: <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com> <alpine.LFD.2.00.1001232051510.3574@localhost.localdomain> <m33a1tnbd9.fsf@fleche.redhat.com> <alpine.LFD.2.00.1001251332370.3574@localhost.localdomain> <m3636oh2rt.fsf@fleche.redhat.com> <alpine.LFD.2.00.1001261535510.17519@localhost.localdomain> <1264575134.4283.1983.camel@laptop> <alpine.LFD.2.00.1001270231520.24253@localhost.localdomain> <1264589716.4283.2006.camel@laptop> <alpine.LFD.2.00.1001270302200.24253@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001270302200.24253@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 03:04:58AM -0800, Linus Torvalds wrote:
> 
> 
> On Wed, 27 Jan 2010, Peter Zijlstra wrote:
> > 
> > Right, so there's two aspects:
> > 
> >  1) concurrency when inserting the probe
> 
> That's the one I worried about. Stopping all threads will fix it, 
> obviously at a disastrous performance cost, but what do I care? As noted, 
> there are ways to do it safely with TLB switching, so it's fixable.


That said, inserting a probe is supposed to be a pretty rare
operation, stopping all threads in a process shouldn't be
painful for this aspect.

