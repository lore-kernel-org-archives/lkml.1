Return-Path: <linux-kernel-owner+w=401wt.eu-S1756035AbZASSIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbZASSIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 13:08:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbZASSIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 13:08:40 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:23428 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbZASSIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 13:08:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=JXO2IGk6sD1Oq9rvQhqUwR/2cbpdKved/Z3C8RY0GRQ6YUiq6d2+HKp/KH6aFSANNl
         28/C4XPd2ZOUbKCt62IGnUXCd6SGHI573xJcnXaOjRAO3lnqbvAh4Ijw5/ks7ItHDj0m
         ZAFOFm1QJTGeqpqpMNhhvfTi9Q5+SLwd2WSjQ=
Subject: Re: [GIT PULL -tip v3] fix 39 'make headers_check' warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090119111552.GA18996@elte.hu>
References: <1232287474.3130.19.camel@localhost.localdomain>
	 <20090118172800.GB22624@elte.hu> <20090118185034.GA26908@elte.hu>
	 <1232331011.3129.4.camel@localhost.localdomain>
	 <1232331646.5570.5.camel@brick>  <20090119111552.GA18996@elte.hu>
Content-Type: text/plain
Date: Mon, 19 Jan 2009 10:08:35 -0800
Message-Id: <1232388515.5488.6.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-19 at 12:15 +0100, Ingo Molnar wrote:
> * Harvey Harrison <harvey.harrison@gmail.com> wrote:
> > 
> > As part of doing the swab.h splitout it was very tempting to just stop 
> > exporting _all_ of the asm/swab.h files now that there is a 
> > linux/swab.h. But I ended up leaving things as they were on arches that 
> > did expose their arch specific versions to userspace.
> 
> i'd argue for a much narrower interface to user-space - we export so much 
> stuff (more than 700 headers) and in such an unstructured way (75,000 
> lines of code) that it's plain crazy.
> 
> So if you think no x86 userspace actually needs swab.h, we can just wrap 
> it all in __KERNEL__. I guess we cannot remove swab.h from 
> include/linux/Kbuild, right?
> 

Correct, include/linux/swab.h must stay as it provides the actual implementation
for the endian helpers cpu_to_le16, etc.  But now that I've gotten all of this
split out of byteorder.h, we can hide all of the arch overrides by wrapping
the include of asm/swab.h in ifdef __KERNEL__ and unexporting it.  That would
mean userpsace only gets the open-coded C versions and no inline asm from arch
overrides.

So, there wouldn't be any breakage, just possibly pessimization of generated
code if the compiler won't generate the optimized byteswaps on that arch.

Harvey

