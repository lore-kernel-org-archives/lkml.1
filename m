Return-Path: <linux-kernel-owner+w=401wt.eu-S1752697AbYIXV3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbYIXV3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 17:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbYIXV3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 17:29:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbYIXV3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 17:29:15 -0400
Date: Wed, 24 Sep 2008 17:24:33 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Martin Bligh <mbligh@google.com>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       rostedt@goodmis.org, peterz@infradead.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, akpm@linux-foundation.org,
       prasad@linux.vnet.ibm.com, compudj@krystal.dyndns.org,
       dwilder@us.ibm.com, hch@lst.de, zanussi@comcast.net,
       srostedt@redhat.com
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
Message-ID: <20080924212433.GB14763@redhat.com>
References: <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809241340500.6759@gandalf.stny.rr.com> <alpine.LFD.1.10.0809241313000.3265@nehalem.linux-foundation.org> <20080924.133720.72895701.davem@davemloft.net> <33307c790809241351k53f322a1o794dd73255393e11@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33307c790809241351k53f322a1o794dd73255393e11@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Wed, Sep 24, 2008 at 01:51:55PM -0700, Martin Bligh wrote:
> [...]
> One thing we said we could do is compile the "decompaction" tools
> along with the kernel, in the kernel tree. Then if we change the in-kernel
> format, you don't break all the userspace tools. 

If the common tracing idea still includes kernel-supplied ASCII as an
alternative to binary (so that one could grep some debugfs file), then
it would be nice to have some common code for decoding the trace
records offline.

If we can associate a simple specific struct type ("struct
ftrace_event") with each trace id type in an object-code-resident
table, we could automate some of this.  The kernel build process could
sniff dwarf data (a la acme's struct-layout-printing dwarves) at or
before modpost time to generate a snippet of C code for each such
event struct.  That C code could be the generic ASCII-printing
callback for use by debugfs.  A variant could be a userspace-usable
version.  Given the same id-to-struct-name mapping, Sytemtap could
expose event records field by field, by name.


- FChE
