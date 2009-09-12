Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbZILFzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbZILFzx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 01:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbZILFzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 01:55:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59040 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753423AbZILFzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 01:55:51 -0400
Date: Fri, 11 Sep 2009 22:52:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Arjan van de Ven <arjan@infradead.org>, Roland McGrath <roland@redhat.com>,
       torvalds@linux-foundation.org, jakub@redhat.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       x86@kernel.org
Subject: Re: [PATCH 1/2] UNREACHABLE() macro
Message-Id: <20090911225228.e67460f5.akpm@linux-foundation.org>
In-Reply-To: <4AAB26FE.7010309@kernel.org>
References: <20090910015923.8FB628AE5F@magilla.sf.frob.com>
	<20090910020031.87DC68BF6E@magilla.sf.frob.com>
	<20090911134528.cd1782d9.akpm@linux-foundation.org>
	<20090911215525.12B366A98F@magilla.sf.frob.com>
	<20090912054906.22b05848@infradead.org>
	<4AAB26FE.7010309@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Sep 2009 21:43:42 -0700 "H. Peter Anvin" <hpa@kernel.org> wrote:

> On 09/11/2009 08:49 PM, Arjan van de Ven wrote:
> > On Fri, 11 Sep 2009 14:55:25 -0700 (PDT)
> > Roland McGrath <roland@redhat.com> wrote:
> > 
> >>> That's a bit of a mouthful.  Did you consider a runtime probe with
> >>> scripts/Kbuild.include's try-run, cc-option, etc?  
> >>
> >> I did not see any precedent in the sources for using those to test for
> >> features by compiling particular test sources (i.e. in autoconf
> > 
> > look at the stackprotector flags.. they work this way already.
> > It gets done once per kernel build...
> > 
> 
> That works for flags, but not for the presence of builtin functions.
> You can't even just try compiling something, since it will turn into an
> ordinary function if not present... not obvious until link.
> 

Use -Wall -Werror and if the compiler doesn't know about
__builtin_unreachable() it will error out.

