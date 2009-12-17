Return-Path: <linux-kernel-owner+w=401wt.eu-S936200AbZLQEKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936200AbZLQEKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:10:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936282AbZLQEJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:09:39 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:33158
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936296AbZLQEJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:09:36 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: CONFIG_KPROBES=y build requires gawk
Date: Wed, 16 Dec 2009 22:09:28 -0600
User-Agent: KMail/1.11.2 (Linux/2.6.28-16-generic; KDE/4.2.2; x86_64; ; )
Cc: Roland Dreier <rdreier@cisco.com>, Andrew Isaacson <adi@vmware.com>,
       Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       Masami Hiramatsu <mhiramat@redhat.com>
References: <20091216235617.GA12267@hexapodia.org> <adabphy750b.fsf@roland-alpha.cisco.com> <4B299AB5.7020109@zytor.com>
In-Reply-To: <4B299AB5.7020109@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912162209.29744.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 December 2009 20:43:01 H. Peter Anvin wrote:
> On 12/16/2009 05:39 PM, Roland Dreier wrote:
> > Is there any reason not to apply the patch below, to allow more awk
> > implementations to be used?  After all, it's not like we're going to put
> > non-ASCII characters into the map file...
>
> I guess the question is if it will break under any other circumstances,
> but I guess we can find those when we get to them.
>
> There was a long discussion about the use of awk on IRC today.
> Apparently mawk, in particular, is actively broken, because the
> maintainer believe that POSIX is crap.  There are quite a few issues
> with it, according to reports.

if the kernel specifies posix, and that implementation doesn't do posix, then 
that implementation doesn't build the kernel.  Blacklisting known broken 
implementations makes a certain amount of sense.

> We need a sane scripting language available to the kernel build, and
> given all the problems we have had with different versions or even just
> sometimes different builds of sh, awk, and even bc -- plus the fact that
> those utilities just don't necessarily do what we want makes it very
> frustrating.

1) Posix exists for a reason.

2) Busybox implements what the kernel has needed to build.  (I test this every 
release, and I fix it where necessary.)

> Personally I think a dependency on Perl is better than the
> mess we're in; I understand other people disagree.

Vehemently.

> What is definitely
> not acceptable, however, is the status quo.  The situation is, quite
> frankly, ridiculous enough that perhaps the right thing to do is to
> write a small scripting engine and bundle it with the kernel.  Something
> that does what we need it to do, but is only one implementation and
> something we can extend at will if need be.

*shrug*  That's one way to avoid environmental dependencies.

> 	-hpa

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
