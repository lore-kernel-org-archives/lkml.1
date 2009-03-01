Return-Path: <linux-kernel-owner+w=401wt.eu-S1758590AbZCAXeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590AbZCAXeZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 18:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757130AbZCAXeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 18:34:17 -0500
Received: from gw.goop.org ([64.81.55.164]:43425 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757111AbZCAXeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 18:34:16 -0500
Message-ID: <49AB1B75.2060200@goop.org>
Date: Sun, 01 Mar 2009 15:34:13 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] xen: core dom0 support
References: <1235786365-17744-1-git-send-email-jeremy@goop.org>	<20090227212812.26d02f34.akpm@linux-foundation.org>	<49A8DF28.4050301@goop.org> <87eixi35ew.fsf@basil.nowhere.org>
In-Reply-To: <87eixi35ew.fsf@basil.nowhere.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> I would say the more interesting question is less how much additional
> code it is or even how much it changes the main kernel, but more how
> different the code execution paths in interaction with Xen are
> compared to what a native kernel would do. Because such differences
> always would need to be considered in future changes.
>   

Yes.  A big part of what I'm doing is trying to keep the Xen changes 
self-contained to try and minimize their system-wide impact.  Basically 
it comes down to that if you use (mostly existing) kernel APIs in the 
way they're intended to be used, then things just work out for both Xen 
and native cases.  The whole point of keeping the kernel modular is so 
that if people implement and use the the interfaces correctly, the 
internal details shouldn't matter very much.  Often the process of 
adding Xen support has resulted in putting clear, well defined 
interfaces into parts of the kernel where previously things were, well, 
in need of cleaning up.

> For example things like: doesn't use PAT with Xen or apparently very
> different routing are somewhat worrying because it means it's a
> completely different operation modus with Xen that needs to be taken
> care of later, adding to complexity.
>   

Unless we're planning on dropping support for processes with no or 
broken PAT support, we're always going to have to deal with the non-PAT 
case.  Xen just falls into the "processor with no PAT" case.  And 
if/when we work out how to paravirtualize PAT, it will no longer be in 
that case.

> Unfortunately it also looks like that Xen the HV does things
> more and more different from what mainline kernel does so 
> these differences will likely continue to grow over time.

I hope that won't be the case. As part of considering any change to Xen 
is considering what changes would be needed to the guest operating 
systems to make use of that feature.

    J
