Return-Path: <linux-kernel-owner+w=401wt.eu-S1758766AbZBYHFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766AbZBYHFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 02:05:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbZBYHF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 02:05:28 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50947 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbZBYHF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 02:05:28 -0500
Date: Wed, 25 Feb 2009 02:05:11 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kyle McMartin <kyle@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>, mingo@redhat.com,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [rfc] headers_check cleanups break the whole world
Message-ID: <20090225070511.GG6690@bombadil.infradead.org>
References: <20090225032553.GD6690@bombadil.infradead.org> <20090225065632.GB21903@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225065632.GB21903@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 07:56:32AM +0100, Ingo Molnar wrote:
> Note that if user-space is "playing utterly stupid games", it 
> can cause trouble no matter what scheme we pick - so we have to 
> filter out the reasonable problems that we should and can fix in 
> the kernel.
> 

Yeah, sorry, I should have been clearer, libcap does stupid
#define _LINUX_TYPES_H_
typedef unsigned int __u32;
#include <linux/header.h>

Which is just horribly broken when it's included early in a file and
then we try to #include <asm/sigcontext.h> (and doesn't get the rest
of those types since it now includes <linux/types.h> instead of
<asm/types.h>) (coreutils was doing this.)

The real case is something like using the dvb headers, which legitimately
is trying to include both <sys/*.h> and then <linux/dvb/*.h> and expecting
it to work.

The footnote in the prior mail was really just an example of why not
having just the plain __u32 et al types in their own header.

regards, Kyle
