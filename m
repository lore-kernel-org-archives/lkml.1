Return-Path: <linux-kernel-owner+w=401wt.eu-S1761761AbXH3PdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761761AbXH3PdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 11:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758218AbXH3PdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 11:33:13 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:49678 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757621AbXH3PdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 11:33:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=mmor2/EnfT8o8EV5eMMOsT86H/2OYIth1Of9jv1C5JY29TF1PDkWul4huN7mnoke1Q2VVLY97JJt/n+8eOv3zOL/xy/6Kb7u+JOKC+rNyyoLjGX1A5XFD9nAwU8rZWRkEuiAXlMPJjMa3p+RuRqthgHZieC05IcU/HKG0gzl11o=
Message-ID: <46D6E32F.30204@gmail.com>
Date: Thu, 30 Aug 2007 17:33:03 +0200
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Mike Frysinger <vapier.adi@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386 and x86_64: randomize brk()
References: <Pine.LNX.4.64.0708301545100.4135@jikos.suse.cz>  <8bd0f97a0708300701r1f36bc0anc45b9cad4a11f2ef@mail.gmail.com>  <Pine.LNX.4.64.0708301620010.4135@jikos.suse.cz> <8bd0f97a0708300726h563808a6j2b2ef9adf805c109@mail.gmail.com> <Pine.LNX.4.64.0708301708590.4135@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0708301708590.4135@jikos.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Thu, 30 Aug 2007, Mike Frysinger wrote:
> 
>> Blackfin too please :) i think v850 also falls into this category, but 
>> i'm not terribly familiar with it ...
> 
> Andrew, do you still strongly oppose to having ARCH_HAS_RANDOMIZE_BRK 
> macro instead please?
> 

you might want to use a weak function instead ?

void __weak arch_randomize_brk(void)
{
	/* nada by default */
}

and overload it only for x86 architectures by now.

BTW, how about minimize the arch specific code by slighly changing its
prototype  ?

unsigned long arch_randomize_brk(struct mm_struct *mm)
{
	unsigned long range_end = mm->brk + 0x02000000;
	
	return randomize_range(mm->brk, range_end, 0) ? : mm->brk;
}

		Franck
