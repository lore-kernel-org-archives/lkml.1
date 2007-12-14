Return-Path: <linux-kernel-owner+w=401wt.eu-S1758407AbXLNHvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758407AbXLNHvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 02:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750821AbXLNHvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 02:51:12 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:48005 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbXLNHvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 02:51:10 -0500
Date: Fri, 14 Dec 2007 13:21:06 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Srinivasa Ds <srinivasa@in.ibm.com>, linux-kernel@vger.kernel.org,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>, rusty@rustcorp.com.au
Subject: Re: [RFC] [patch 1/2] add non_init_kernel_text_address
Message-ID: <20071214075106.GA13249@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <200712141225.30099.srinivasa@in.ibm.com> <20071213230916.cd30de8c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071213230916.cd30de8c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 11:09:16PM -0800, Andrew Morton wrote:
> On Fri, 14 Dec 2007 12:25:30 +0530 Srinivasa Ds <srinivasa@in.ibm.com> wrote:
> 
> > Since __init functions are discarded and its memory freed once
> > initialization completes, It would be better if we enable kprobes 
> > to refuse probing __init functions. The attached patchset will do 
> > that.
> > 
> > This patch creates non_init_kernel_text_address() to identify
> > non_init text area.
> > 
> > Iam open to suggestions for a better functionname. 
> > 
> 
> It's not a great name.  One wonders how it handles __exit text, for example.

When registering kprobes on modules, we 'get' a module refcount so the
probed module doesn't disappear from under us. When the probe is
unregistered, we 'put' the refcount. That works great for __exit text.

> regular_kernel_text_address()?  Dunno.

Sounds better :-)

Ananth
