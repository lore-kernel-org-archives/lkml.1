Return-Path: <linux-kernel-owner+w=401wt.eu-S1945982AbXDCVnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945982AbXDCVnF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 17:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688AbXDCVnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 17:43:05 -0400
Received: from waste.org ([66.93.16.53]:39709 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753686AbXDCVnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 17:43:04 -0400
Date: Tue, 3 Apr 2007 16:30:29 -0500
From: Matt Mackall <mpm@selenic.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Reorganizing structs to save space
Message-ID: <20070403213028.GV10459@waste.org>
References: <20070403122848.GA14224@ghostprotocols.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070403122848.GA14224@ghostprotocols.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 09:28:48AM -0300, Arnaldo Carvalho de Melo wrote:
> module                     16960 16848 112

That's huge.

> 	struct module_ref          ref[255];             /*   480 16320 */

Huh. That's this:

struct module_ref
{
        local_t count;
} ____cacheline_aligned;

This is horrible. Surely there's some way to do better than a
cacheline per module per possible CPU. We should only need 4 bytes per
module per online CPU.

And really, about the only case where we actually care about cacheline
bouncing here at all is on modules that do this per-packet. Just about
everyone else can get by with 4 bytes per module total.

-- 
Mathematics is the supreme nostalgia of our time.
