Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbXLDS6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbXLDS6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 13:58:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbXLDS5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 13:57:52 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48410 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbXLDS5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 13:57:51 -0500
Date: Tue, 4 Dec 2007 18:57:44 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>, David Smith <dsmith@redhat.com>
Subject: Re: [patch 2/2] Linux Kernel Markers - Create modpost file
Message-ID: <20071204185744.GB21568@infradead.org>
References: <20071204181845.895090222@polymtl.ca> <20071204182403.319351701@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071204182403.319351701@polymtl.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 01:18:47PM -0500, Mathieu Desnoyers wrote:
> This adds some new magic in the MODPOST phase for CONFIG_MARKERS.
> Analogous to the Module.symvers file, the build will now write a
> Module.markers file when CONFIG_MARKERS=y is set.  This file lists
> the name, defining module, and format string of each marker,
> separated by \t characters.  This simple text file can be used by
> offline build procedures for instrumentation code, analogous to
> how System.map and Module.symvers can be useful to have for
> kernels other than the one you are running right now.
> 
> The strings are made easy to extract by having the __trace_mark macro
> define the name and format together in a single array called __mstrtab_*
> in the __markers_strings section.  This is straightforward and reliable
> as long as the marker structs are always defined by this macro.  It is
> an unreasonable amount of hairy work to extract the string pointers from
> the __markers section structs, which entails handling a relocation type
> for every machine under the sun.

Generating something like this might make sense.  But until you actually
add ome example code, e.g. to generate a tracing module for each probe
marker in a given module I don't see any point in adding this.

