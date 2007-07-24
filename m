Return-Path: <linux-kernel-owner+w=401wt.eu-S1758840AbXGXOa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840AbXGXOa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 10:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756482AbXGXOaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 10:30:06 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:35745 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288AbXGXOaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 10:30:01 -0400
Subject: Re: [PATCH respin, was PATCH for review] During VM oom condition,
	kill all threads in process group
From: Will Schmidt <will_schmidt@vnet.ibm.com>
Reply-To: will_schmidt@vnet.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Christoph Hellwig <hch@infradead.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <20070723141641.5759a287.akpm@linux-foundation.org>
References: <20070719348.540885000@suse.de>
	 <20070719134840.47B5114E6E@wotan.suse.de>
	 <20070719140411.GD16279@infradead.org>
	 <Pine.LNX.4.64.0707191614180.7377@anakin>
	 <1185214185.22237.30.camel@farscape.rchland.ibm.com>
	 <20070723141641.5759a287.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: IBM
Date: Tue, 24 Jul 2007 09:28:44 -0500
Message-Id: <1185287324.22237.39.camel@farscape.rchland.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-23 at 14:16 -0700, Andrew Morton wrote:
> On Mon, 23 Jul 2007 13:09:45 -0500
> Will Schmidt <will_schmidt@vnet.ibm.com> wrote:
> 
> > During VM oom condition, kill all threads in process group.
> > 
> > We have had complaints where a threaded application is left in a bad
> > state after one of it's threads is killed when we hit a VM: out_of_memory
> > condition.
> > Killing just one of the process threads can leave the application in a
> > bad state, whereas killing the entire process group would allow for
> > the application to restart, or be otherwise handled, and makes it very
> > obvious that something has gone wrong.
> > 
> > This change allows the entire process group to be taken down, rather
> > than just the one thread.
> 
> Just checking...
> 
> blackfin
> h8300
> m68knommu
> uml
> v850
> 
> were not changed.  Intentional?

Yes.  Those arch's don't have the VM oom code that I could see.   There
is an occasional do_exit() reference elsewhere in the fault handler
code, for reasons other than VM oom, so I deliberately didn't touch
those either.    



