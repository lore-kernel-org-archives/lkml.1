Return-Path: <linux-kernel-owner+w=401wt.eu-S1762977AbXHQVOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762977AbXHQVOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 17:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755321AbXHQVOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 17:14:18 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48539 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753035AbXHQVOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 17:14:17 -0400
Date: Fri, 17 Aug 2007 14:14:17 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Satyam Sharma <satyam@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: kfree(0) - ok?
In-Reply-To: <alpine.LFD.0.999.0708180011570.3666@enigma.security.iitk.ac.in>
Message-ID: <Pine.LNX.4.64.0708171413190.9635@schroedinger.engr.sgi.com>
References: <46C233CB.9000602@am.sony.com> <1187132149.2618.2.camel@laptopd505.fenrus.org>
 <alpine.LFD.0.999.0708150454480.6482@enigma.security.iitk.ac.in>
 <20070817112253.e6a7cb33.akpm@linux-foundation.org>
 <alpine.LFD.0.999.0708180011570.3666@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Aug 2007, Satyam Sharma wrote:

> >  	page = get_object_page(object);
> 
> Hmm, I didn't know ksize(NULL) was also allowed to succeed (and
> return 0).

That was merged over my objections. IMHO ksize(NULL) should fail since we 
are determining the size of an unallocated object.

> Oh yes, of course. We want krealloc(NULL) cases to behave consistently 
> as expected, and letting ksize(NULL) return 0 means the code for 
> krealloc() can lose an extra "if (!p)" check that would otherwise have 
> been required. Cool.

krealloc should check for that.
