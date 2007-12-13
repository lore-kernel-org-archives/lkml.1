Return-Path: <linux-kernel-owner+w=401wt.eu-S1753299AbXLMWlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbXLMWlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 17:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755492AbXLMWlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 17:41:10 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:45638 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752826AbXLMWlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 17:41:09 -0500
Date: Thu, 13 Dec 2007 23:41:11 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: RFC: remove __read_mostly
Message-ID: <20071213224111.GI21616@stusta.de>
References: <20071213222044.GH21616@stusta.de> <p73bq8ugrez.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <p73bq8ugrez.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 11:29:08PM +0100, Andi Kleen wrote:
> Adrian Bunk <bunk@kernel.org> writes:
> >
> > -rwxrwxr-x 1 bunk bunk 46607243 2007-12-13 19:50 vmlinux.old
> > -rwxrwxr-x 1 bunk bunk 46598691 2007-12-13 21:55 vmlinux
> 
> File sizes are useless -- check size output.

    text    data     bss      dec     hex filename
29268488 3697961 5222400 38188849 246b731 vmlinux.old
29268435 3685565 5228784 38192784 246c690 vmlinux

> > It's not a surprise that the kernel can become bigger when __read_mostly 
> > gets used, especially in cases where __read_mostly prevents gcc 
> > optimizations.
> 
> What optimizations do you think it prevents?  I don't think it 
> should change the gcc generated code at all; the only difference
> should be to the linker.

What I have seen recently was a static variable marked __read_mostly 
being read-only with some CONFIG_DEBUG_FOO=n.

With __read_mostly gcc feeled obliged to emit a variable.

Without __read_mostly, gcc optimized the variable away.

> -Andi

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

