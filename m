Return-Path: <linux-kernel-owner+w=401wt.eu-S1752754AbXCRApa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbXCRApa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 20:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbXCRApa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 20:45:30 -0400
Received: from ozlabs.org ([203.10.76.45]:32848 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754AbXCRAp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 20:45:28 -0400
Subject: Re: [patch 14/26] Xen-paravirt_ops: add common patching machinery
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@muc.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Anthony Liguori <anthony@codemonkey.ws>
In-Reply-To: <20070316092054.GK23174@elte.hu>
References: <20070301232443.195603797@goop.org>
	 <20070301232528.055105942@goop.org>  <20070316092054.GK23174@elte.hu>
Content-Type: text/plain
Date: Sat, 17 Mar 2007 20:15:36 +1100
Message-Id: <1174122936.8897.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-16 at 10:20 +0100, Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > Implement the actual patching machinery.  paravirt_patch_default() 
> > contains the logic to automatically patch a callsite based on a few 
> > simple rules:
> > 
> >  - if the paravirt_op function is paravirt_nop, then patch nops
> >  - if the paravirt_op function is a jmp target, then jmp to it
> >  - if the paravirt_op function is callable and doesn't clobber too much
> >     for the callsite, call it directly
> > 
> > paravirt_patch_default is suitable as a default implementation of 
> > paravirt_ops.patch, will remove most of the expensive indirect calls 
> > in favour of either a direct call or a pile of nops.
> 
> Acked-by: Ingo Molnar <mingo@elte.hu>

I like this one too, but note that it needs a twist when we change to
use direct calls to wrappers for the Great paravirt_ops Unexporting.

Rusty.


