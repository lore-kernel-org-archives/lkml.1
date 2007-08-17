Return-Path: <linux-kernel-owner+w=401wt.eu-S932282AbXHQVd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282AbXHQVd3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 17:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759926AbXHQVdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 17:33:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33280 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760456AbXHQVdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 17:33:19 -0400
Date: Sat, 18 Aug 2007 03:16:01 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Christoph Lameter <clameter@sgi.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: kfree(0) - ok?
In-Reply-To: <Pine.LNX.4.64.0708171413190.9635@schroedinger.engr.sgi.com>
Message-ID: <alpine.LFD.0.999.0708180309320.3666@enigma.security.iitk.ac.in>
References: <46C233CB.9000602@am.sony.com> <1187132149.2618.2.camel@laptopd505.fenrus.org>
 <alpine.LFD.0.999.0708150454480.6482@enigma.security.iitk.ac.in>
 <20070817112253.e6a7cb33.akpm@linux-foundation.org>
 <alpine.LFD.0.999.0708180011570.3666@enigma.security.iitk.ac.in>
 <Pine.LNX.4.64.0708171413190.9635@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 17 Aug 2007, Christoph Lameter wrote:

> On Sat, 18 Aug 2007, Satyam Sharma wrote:
> 
> > Hmm, I didn't know ksize(NULL) was also allowed to succeed (and
> > return 0).
> 
> That was merged over my objections. IMHO ksize(NULL) should fail since we 
> are determining the size of an unallocated object.

Agreed, I'd have implemented ksize() that oops'ed on NULL, myself.
For that matter, I'd wish that kfree() oops'ed on NULL too (and have
duly participated in such a flamewar once), but not many (if any) on
this list seem to sympathize with such an opinion :-)

> > Oh yes, of course. We want krealloc(NULL) cases to behave consistently 
> > as expected, and letting ksize(NULL) return 0 means the code for 
> > krealloc() can lose an extra "if (!p)" check that would otherwise have 
> > been required. Cool.
> 
> krealloc should check for that.

Agreed again, explicitly checking for that only sounds fair to me.
