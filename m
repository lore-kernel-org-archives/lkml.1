Return-Path: <linux-kernel-owner+w=401wt.eu-S1757991AbXKTD3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991AbXKTD3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 22:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755496AbXKTD3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 22:29:09 -0500
Received: from tomts36.bellnexxia.net ([209.226.175.93]:36762 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755504AbXKTD3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 22:29:08 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAErjQUdMROHU/2dsb2JhbACBW48G
Date: Mon, 19 Nov 2007 22:29:04 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: ak@suse.de, akpm@linux-foundation.org, travis@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 45/45] Modules: Hack to handle symbols that have a zero
	value
Message-ID: <20071120032904.GB21743@Krystal>
References: <20071120011132.143632442@sgi.com> <20071120011342.426906810@sgi.com> <20071120022007.GA16899@Krystal> <Pine.LNX.4.64.0711191849180.21479@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711191849180.21479@schroedinger.engr.sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:19:14 up 16 days,  8:24,  3 users,  load average: 0.57, 0.69,
	0.99
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (clameter@sgi.com) wrote:
> On Mon, 19 Nov 2007, Mathieu Desnoyers wrote:
> 
> > * clameter@sgi.com (clameter@sgi.com) wrote:
> > > The module subsystem cannot handle symbols that are zero. It prints out
> > > a message that these symbols are unresolved. Define a constant
> > > 
> > > UNRESOLVED
> > > 
> > > that is used to hold the value used for unresolved symbols. Set it to 1
> > > (its hopefully unlikely that a symbol will have the value 1). This is necessary
> > > so that the pda variable which is placed at offset 0 of the per cpu
> > > segment is handled correctly.
> > > 
> > 
> > Wouldn't it be better to simply return a standard ERR_PTR(-ENO....) ?
> 
> Good idea. But can you guarantee that this wont clash with an address?
> 

linux/err.h assumes that the last page of the address space is never
ever used. Is that a correct assumption ?

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
