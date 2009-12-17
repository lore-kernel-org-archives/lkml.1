Return-Path: <linux-kernel-owner+w=401wt.eu-S1758601AbZLQCuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601AbZLQCuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 21:50:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820AbZLQCuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 21:50:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56482 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbZLQCuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 21:50:16 -0500
Message-ID: <4B299AB5.7020109@zytor.com>
Date: Wed, 16 Dec 2009 18:43:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Andrew Isaacson <adi@vmware.com>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, Masami Hiramatsu <mhiramat@redhat.com>,
       Rob Landley <rob@landley.net>
Subject: Re: CONFIG_KPROBES=y build requires gawk
References: <20091216235617.GA12267@hexapodia.org> <adabphy750b.fsf@roland-alpha.cisco.com>
In-Reply-To: <adabphy750b.fsf@roland-alpha.cisco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2009 05:39 PM, Roland Dreier wrote:
> Is there any reason not to apply the patch below, to allow more awk
> implementations to be used?  After all, it's not like we're going to put
> non-ASCII characters into the map file...

I guess the question is if it will break under any other circumstances,
but I guess we can find those when we get to them.

There was a long discussion about the use of awk on IRC today.
Apparently mawk, in particular, is actively broken, because the
maintainer believe that POSIX is crap.  There are quite a few issues
with it, according to reports.

We need a sane scripting language available to the kernel build, and
given all the problems we have had with different versions or even just
sometimes different builds of sh, awk, and even bc -- plus the fact that
those utilities just don't necessarily do what we want makes it very
frustrating.  Personally I think a dependency on Perl is better than the
mess we're in; I understand other people disagree.  What is definitely
not acceptable, however, is the status quo.  The situation is, quite
frankly, ridiculous enough that perhaps the right thing to do is to
write a small scripting engine and bundle it with the kernel.  Something
that does what we need it to do, but is only one implementation and
something we can extend at will if need be.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

