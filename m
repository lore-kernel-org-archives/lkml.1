Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab0CAEDx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 23:03:53 -0500
Received: from mail-qy0-f179.google.com ([209.85.221.179]:41626 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab0CAEDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 23:03:51 -0500
Date: Sun, 28 Feb 2010 23:03:46 -0500 (EST)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: Michal Marek <mmarek@suse.cz>
cc: Denys Vlasenko <vda.linux@googlemail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
       Bjorn Wesen <bjornw@axis.com>, Tim Bird <tim.bird@am.sony.com>,
       Anders Kaseorg <andersk@ksplice.com>, Waseem Daher <wdaher@ksplice.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "H. Peter Anvin" <hpa@zytor.com>, Barry Song <barry.song@analog.com>,
       Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH 00/24] Rename kernel's magic sections for compatibility
 with -ffunction-sections -fdata-sections
In-Reply-To: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
Message-ID: <alpine.DEB.1.10.1002282111280.6474@dr-wily.mit.edu>
References: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Feb 2010, Denys Vlasenko wrote:

> Here is a new version of the -ffunction-sections -fdata-sections patch
> series based on current Linus tree.

Aside from patch 17, which I would prefer that Haavard review, these 
patches look correct (and patch 17 can be safely dropped).  Please 
consider the rest of Denys' patches in this patch series

Acked-by: Tim Abbott <tabbott@ksplice.com>

The patches still apply fine on Linus' current master.  There are no merge 
conflicts with linux-next's current master, but we will need to do 
something to merge with

"Blackfin: initial XIP support"

in linux-next, which introduces a direct reference to .data.percpu.* (not 
using the normal PERCPU macros so they can put .data.percpu content inside 
the .init.data section).  That conflict looks easy to deal with by adding 
a new macro to handle this case (CCing the author and blackfin maintainer; 
it's possible that this blackfin patch is going in soon, in which case we 
can just rebase these patches on top).

Michal, what are your thoughts on this patch series?  The kbuild tree 
would be a reasonable path for merging these patches.

	-Tim Abbott
