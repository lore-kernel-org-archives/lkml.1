Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842AbZANGr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbZANGr7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 01:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbZANGru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 01:47:50 -0500
Received: from crmm.lgl.lu ([158.64.72.228]:37094 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbZANGrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 01:47:49 -0500
Message-ID: <496D8A83.1040801@knaff.lu>
Date: Wed, 14 Jan 2009 07:47:31 +0100
From: Alain Knaff <alain@knaff.lu>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Bodo Eggert <7eggert@gmx.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@ftp.linux.org.uk>
Subject: Re: The policy on initramfs decompression failure
References: <bU0fj-7Ap-43@gated-at.bofh.it> <E1LMstm-0001QW-7i@be1.7eggert.dyndns.org> <20090114054556.GB11153@elte.hu>
In-Reply-To: <20090114054556.GB11153@elte.hu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> So basically now the kernel has regressed in its bzImage utility: "oh, i 
> dont have a decompressor for the initrd. PANIC!". And that is a step 
> backwards.

Well, for the precise case of gzip I agree with you. The reason why you
are right in that special case is that gzip used to be the *only*
decompressor available, so it was always available, so you couldn't
easily chose a config option which removes the decompressor for a gzip
initrd.

However, if you think in more general terms, you _could_ get into that
case by attempting to boot up using a bzip2-compressed initrd. If you
fed such an initrd to the old unpatched code, you'd get an exception at
exactly the same place (populate_rootfs) for exactly the same reason
(kernel doesn't have a decompressor for the initrd). Please think about
it...

I'm not against fixing old problems with new code, that's in general a
good thing. What I do have an issue with is that this seems to become
_mandatory_, at least in this case...

And the result of such strictness will not be better code, but stagnant
code. Nobody will be able to address one problem, because anybody
attempting to do that will have his patch rejected because it doesn't
also solve the "hunger in the 3rd world" problem.

> Unless you use bzImage i dont think you can really appreciate 
> this argument.

Maybe that's the source of our misunderstanding. What is this bzImage?
(I suppose it's not just the kernel name/format but something more. But
what?)

Regards,

Alain
