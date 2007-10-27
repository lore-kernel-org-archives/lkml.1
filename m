Return-Path: <linux-kernel-owner+w=401wt.eu-S1755753AbXJ0TQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbXJ0TQf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 15:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbXJ0TQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 15:16:28 -0400
Received: from smtp-out.google.com ([216.239.33.17]:52561 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbXJ0TQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 15:16:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=L9XCx3aA1uC/E1ABM3CQ6f7cnCohs+XWD3h6uRCp3LLhnEev796HmmAJaOXb+4rvQ
	YHXgMdmRl0ryj/U0pOlvQ==
Date: Sat, 27 Oct 2007 12:16:12 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
In-Reply-To: <alpine.DEB.0.9999.0710261136500.11674@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.0.9999.0710271212450.19199@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>  <alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com>  <Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com>  <alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
  <Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com> <1193411888.5032.9.camel@localhost> <alpine.DEB.0.9999.0710261136500.11674@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007, David Rientjes wrote:

> Hacking and requiring an updated version of libnuma to allow empty 
> nodemasks to be passed is a poor solution; if mempolicy's are supposed to 
> be independent from cpusets, then what semantics does an empty nodemask 
> actually imply when using MPOL_INTERLEAVE?  To me, it means the entire 
> set_mempolicy() should be a no-op, and that's exactly how mainline 
> currently treats it _as_well_ as libnuma.  So justifying this change in 
> the man page is respectible, but passing an empty nodemask just doesn't 
> make sense.
> 

Another reason that passing an empty nodemask to set_mempolicy() doesn't 
make sense is that libnuma uses numa_set_interleave_mask(&numa_no_nodes)
to disable interleaving completely.

		David
