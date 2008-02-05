Return-Path: <linux-kernel-owner+w=401wt.eu-S1755427AbYBEHWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbYBEHWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 02:22:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751097AbYBEHWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 02:22:33 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44332 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbYBEHWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 02:22:32 -0500
Date: Mon, 4 Feb 2008 23:22:15 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Zachary Amsden <zach@vmware.com>
Cc: for.poige+linux@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: > best asked at one of the nvidia forums, not on lkml...
Message-ID: <20080204232215.5063c4d9@laptopd505.fenrus.org>
In-Reply-To: <1202194390.28740.8.camel@bodhitayantram.eng.vmware.com>
References: <43d009740802022335y21c3f93ep4e444bef71338045@mail.gmail.com>
	<20080202235103.20dd9768.akpm@linux-foundation.org>
	<47A71040.5000300@gmail.com>
	<20080204052709.12f4e0d3.akpm@linux-foundation.org>
	<47A7F4DB.3070406@gmail.com>
	<47A80218.3040304@gmail.com>
	<20080204223430.415161e9@laptopd505.fenrus.org>
	<47A805C3.9050303@gmail.com>
	<1202194390.28740.8.camel@bodhitayantram.eng.vmware.com>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Feb 2008 22:53:10 -0800
Zachary Amsden <zach@vmware.com> wrote:

> 
> On Tue, 2008-02-05 at 13:44 +0700, Igor M Podlesny wrote:
> > On 2008-02-05 13:34, Arjan van de Ven wrote:
> > [...]
> > >> 	1) To have compiled it I had to replace
> > >> global_flush_tlb() call with __flush_tlb_all() and still
> > >> guessing was it(?) a correct replacment at all :-)
> > > 
> > > it is not; 
> > 
> > 	I see, thanks. What would be the correct one? ;-)
> 
> global_flush_tlb() would be the correct one.

... except that that function got absorbed into the functions that would otherwise require this guy to be called
(which is a needed step to do more selective clflushes for the specific range rather than wholesale wbinvd's
that flush all 12Mb or your cache while you only need to flush 4Kb... but only the other function knew the exact
range of stuff to flush)

> 


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
