Return-Path: <linux-kernel-owner+w=401wt.eu-S1758017AbZEDPWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017AbZEDPWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 11:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757024AbZEDPU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 11:20:29 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:42007 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757368AbZEDPU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 11:20:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LldCaSQRz+rbWgCvVXZMxzWzAmIiAu45FPMYDjeM6ZZd3NDj2gMdV0Ooi5IbrwBVlj
         cPcJqK5phvLCNT1btLpbTfagalAIw7Gpkcm/Eu3IPbqMWd2B8KPLN3KVksJ/mG2b++Gk
         Gzxz9WDAxVIjdUKtGr2mDDoTL/v8MVGfMkcnM=
Date: Mon, 4 May 2009 19:20:26 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Christoph Lameter <cl@linux.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       LKML <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH -tip] mm: introduce __GFP_PANIC modifier
Message-ID: <20090504152026.GO4173@lenovo>
References: <20090504122740.GH4173@lenovo> <20090504131311.GA23330@elte.hu> <20090504131638.GJ4173@lenovo> <alpine.DEB.1.10.0905040940490.9553@qirst.com> <20090504141256.GK4173@lenovo> <alpine.DEB.1.10.0905041011200.17937@qirst.com> <20090504142903.GM4173@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090504142903.GM4173@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Mon, May 04, 2009 at 06:29:03PM +0400]
| [Christoph Lameter - Mon, May 04, 2009 at 10:13:34AM -0400]
| | On Mon, 4 May 2009, Cyrill Gorcunov wrote:
| | 
| | > As I see page allocator already quite modified in -mm tree.
| | > Christoph will kmalloc with (__GFP_NOFAIL | __GFP_REPEAT)
| | > inform us on exhausted memory? Or we just stuck with blank
| | > screen instead (not blank actually but with previous messages)?
| | 
| | If you do not specify __GFP_NOWARN then it should give you messages,
| | 
| | Guess we need to very that it behaves in the right wya.
| |
| 
| thanks Christoph, I need to read a modified version (which
| is in -mm tree now). Maybe we could find a way indeed :)
| 
| 	-- Cyrill

You know I only found a message in case if page is already
not granted (ie NULL is going to be returned) and right
before that we print a warning about that (nopage: label).
Which means - no panic here and with (__GFP_NOFAIL | __GFP_REPEAT)
just spinning around in attepmt to allocate new memory. And how
to behave on atomic allocations. Almost give up... :)

	-- Cyrill
