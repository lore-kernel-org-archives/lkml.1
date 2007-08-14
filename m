Return-Path: <linux-kernel-owner+w=401wt.eu-S1764483AbXHNPn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764483AbXHNPn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 11:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764206AbXHNPmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 11:42:47 -0400
Received: from igw3.br.ibm.com ([32.104.18.26]:59953 "EHLO igw3.br.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762516AbXHNPmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 11:42:45 -0400
Subject: Re: SLUB doesn't work with kdump kernel on Cell
From: Lucio Correia <ljhc@br.ibm.com>
Reply-To: ljhc@br.ibm.com
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arndb@arndb.de>
In-Reply-To: <Pine.LNX.4.64.0708081321400.14478@schroedinger.engr.sgi.com>
References: <1186604151.3608.46.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0708081321400.14478@schroedinger.engr.sgi.com>
Content-Type: text/plain
Organization: IBM
Date: Tue, 14 Aug 2007 12:43:59 -0300
Message-Id: <1187106239.3298.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-08 at 13:26 -0700, Christoph Lameter wrote:
> On Wed, 8 Aug 2007, Lucio Correia wrote:
> 
> > Hi Christoph,
> > 
> > I found a problem with SLUB when trying to boot a kdump kernel on a Cell
> > QS20 Blade running Fedora 7, kernel 2.6.22.5. If I use SLAB for the
> > kdump kernel, everything works ok. The fact is that SLUB doesn't find a
> > page frame for allocation in the current node, due to the flag
> > GFP_THISNODE on a call to new_slab, and stops at a BUG_ON on line 1802
> > of slub.c. 
> 
> This is due to the node 1 having only one page. Could you just switch node 
> 1 off?
> 
> SLAB boots because it falls back to node 0 for the control structures. So 
> it creates useless control structures for node 1. These are then never 
> used since any allocation  attempt to node 1 falls back to node 0.

Hi Christoph,

Shouldn't SLUB falls back to other node also for the case it can't
allocate memory? 

> 
> > I understand that this flag should not be removed, and that there is a
> > better solution, but it demonstrates the problem. Could you give me some
> > direction on the better way to solve this problem?
> 
> Do not create a node that just has one page in it?
> 
> Or make it truly empty? An empty node will cause GFP_THISNODE to fall back 
> and you then have the same useless control structure allocation as on 
> SLAB.


-- 
Lucio Correia
Software Engineer
IBM LTC Brazil

