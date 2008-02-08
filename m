Return-Path: <linux-kernel-owner+w=401wt.eu-S1762432AbYBHMSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762432AbYBHMSt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 07:18:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756582AbYBHMSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 07:18:40 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:56246 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087AbYBHMSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 07:18:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZPejkErxI8MdujLUTGb2F7fRiluZR4b1pg9984JuiikO/hZnmlgk0E+BxIV6EI5JhBD9KFK4h2Lq/fH7/BQurgL0QucuftZIshaAOAAW4E4vl2wMXNfxRocyXjdiCalfkOMI46cfrZ6JM0VNLQJoDKkQuo3yAGstF2OqrdehhWQ=
Message-ID: <19f34abd0802080418o75969480v3286da7a83ebc178@mail.gmail.com>
Date: Fri, 8 Feb 2008 13:18:37 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH 1/2] kmemcheck v3
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Richard Knutsson" <ricknu-0@student.ltu.se>,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <20080208115542.GD4745@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47AB79D4.2070605@gmail.com>
	 <20080208115542.GD4745@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/8/08, Andi Kleen <andi@firstfloor.org> wrote:
> Your assumption that only the string instructions can take
> multiple page faults seems a little dangerous too.

Yes, this is true. I cannot guarantee that there are no other
instructions that could access more than one memory location but only
take one page fault. However, since the kernel does boot, we at least
know that these instructions are not very frequently used. (If you
know of any other instructions we might be missing, I'll be happy to
know about it!)

There is also the point that if kmemcheck doesn't handle all the
faulting addresses, it will simply fault again and again, without
making any progress. I mean, it won't go unnoticed for very long :-)

This is also why we depend on M386 and !X86_GENERIC, to avoid those
MMX, etc. instructions, as we have no support for those currently.

Sincerely,
Vegard Nossum
