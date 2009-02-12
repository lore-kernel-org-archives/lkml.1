Return-Path: <linux-kernel-owner+w=401wt.eu-S1756739AbZBLGKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbZBLGKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 01:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751001AbZBLGKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 01:10:22 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:45517 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750932AbZBLGKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 01:10:21 -0500
Date: Thu, 12 Feb 2009 01:09:55 -0500 (EST)
From: Tim Abbott <tabbott@MIT.EDU>
To: Jon Masters <jonathan@jonmasters.org>
cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Jeff Arnold <jbarnold@MIT.EDU>, Anders Kaseorg <andersk@MIT.EDU>
Subject: Re: [PATCH 6/9] Ksplice: Add functions for walking kallsyms
 symbols
In-Reply-To: <1234383595.4324.42.camel@jcmlaptop>
Message-ID: <alpine.DEB.2.00.0902111550520.27436@vinegar-pot.mit.edu>
References: <20090207124645.467A2DDDDF@ozlabs.org> <1234383595.4324.42.camel@jcmlaptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Feb 2009, Jon Masters wrote:

> Folks,
> 
> Please forgive me not tracking ksplice closely enough - I didn't think
> it required these changes - is there some refactoring going on currently
> or am I mistaken and these patches are now a necessary pre-req.?

Hi Jon,

There are two different versions of the Ksplice kernel module, a 
"standalone" version that works with an unmodified kernel, and the version 
that we've proposed for mainline merge.

One difference between the two versions is that the standalone version has 
implementations of functions such as kallsyms_on_each_symbol in the 
Ksplice core module (i.e. the module containing ksplice.c).

Normally, one would not be able to implement kallsyms_on_each_symbol in a 
module, because it would not have access to necessary symbols such as 
kallsyms_num_syms (an unexported global symbol).  The standalone version 
of Ksplice resolves these symbols through a bootstrapping process.

This bootstrapping technique doesn't make any sense for a Ksplice in 
mainline; these prerequisite patches put functions such as 
kallsyms_on_each_symbol where they belong.

	-Tim Abbott


