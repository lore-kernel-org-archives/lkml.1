Return-Path: <linux-kernel-owner+w=401wt.eu-S1759198AbXEQV7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759198AbXEQV7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 17:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756287AbXEQV7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 17:59:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58800 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756524AbXEQV7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 17:59:08 -0400
Message-ID: <464CD025.2040106@cv-sv.de>
Date: Thu, 17 May 2007 23:59:01 +0200
From: Christian Volkmann <haveaniceday@cv-sv.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.8.1.2) Gecko/20070218 SUSE/1.1.1-5.1 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Christian Volkmann <haveaniceday@cv-sv.de>,
       linux-kernel@vger.kernel.org, ak@suse.de,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.22-rc1 does not boot on VIA C3_2 cause of X86_CMPXCHG64
References: <464B9D2C.7040704@cv-sv.de> <20070517004209.GE16810@redhat.com> <464BB252.8010008@cv-sv.de> <464CC8E1.5010407@cv-sv.de> <20070517214754.GC398@redhat.com>
In-Reply-To: <20070517214754.GC398@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX183+JNn5opNmK6WmNln7Ew+WE84ZmcrWt99ON8
 TZFLdQmCSWil74veyQvDB6voYm6oKRk/16tQfgg9MOBeJtCM0Y
 vwAx1aVqiDUksYHvIY2sg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Thu, May 17, 2007 at 11:28:01PM +0200, Christian Volkmann wrote:
> Though, I've *never* seen or even heard of someone with one of those CPUs,
> so whether we need to care is questionable. The mp6 did actually make it
> to manufacture aparently, but I don't think anyone actually bought one.
> http://en.wikipedia.org/wiki/Rise_Technology for a pic of this mythical beast.
> 
> 	Dave
> 

> My VIA C7 has the same problem, boots on 486 but not on C3-2 or C7
>
> --
> Hans

I suppose VIA C7 is another candidate for verify_cpu.S

Maybe something like this in assembler might be useful:
if ( ! Intel && ! AMD )
{
   andl    $~NEED_CMPXCHG64,%edx
}

This would not really harm anything but avoid this problem.
But I just don't know x86 to do this proper.

Christian
