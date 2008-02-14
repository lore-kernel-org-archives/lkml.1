Return-Path: <linux-kernel-owner+w=401wt.eu-S1765431AbYBNUaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765431AbYBNUaY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 15:30:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754395AbYBNUaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 15:30:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:52528 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164AbYBNUaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 15:30:10 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Mike Travis <travis@sgi.com>
Subject: Re: [RFC] bitmap relative operator for mempolicy extensions
Date: Thu, 14 Feb 2008 21:30:05 +0100
User-Agent: KMail/1.9.6
Cc: Christoph Lameter <clameter@sgi.com>, Paul Jackson <pj@sgi.com>,
       David Rientjes <rientjes@google.com>, Lee.Schermerhorn@hp.com,
       mel@csn.ul.ie, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20080214123528.25274.84387.sendpatchset@jackhammer.engr.sgi.com> <Pine.LNX.4.64.0802141206100.1041@schroedinger.engr.sgi.com> <47B4A3D7.7040007@sgi.com>
In-Reply-To: <47B4A3D7.7040007@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802142130.06155.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 February 2008 21:25:59 Mike Travis wrote:
> Christoph Lameter wrote:
> > On Thu, 14 Feb 2008, Andi Kleen wrote:
> > 
> >> You're saying the kernel should use these relative masks internally?
> > 
> > There is just some thoughts about this. Did not have time to look into the 
> > details. Mike?
> 
> There are a few places where the entire cpumask is not needed.  For
> example, in the area of core siblings on a node.  There's a limit
> to how many cores/threads can be on a node and the full 4k cpumask
> is not needed.  How this pertains to this new functionality I'm
> not sure yet.

That would require that the BIOS enumerates the CPUs in a way that
the cores of a socket are continuous. While that's usually true
I don't think there's a guarantee. In theory they could be all scattered.

Ok I theory Linux could remap later but that seems hardly worth 
the trouble.

I would rather just use arrays of integers in this case with a reasonable fixed 
upper limit (e.g. 16 or 32 -- if there are ever >32 thread x86 CPUs presumably they will
require an updated cpufreq driver too...) 


-Andi

