Return-Path: <linux-kernel-owner+w=401wt.eu-S1755658AbZETInq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658AbZETInq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 04:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbZETIni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 04:43:38 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:39308 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760AbZETInh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 04:43:37 -0400
Date: Wed, 20 May 2009 10:41:20 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, x86@kernel.org,
       ink@jurassic.park.msu.ru, rth@twiddle.net, linux@arm.linux.org.uk,
       hskinnemoen@atmel.com, cooloney@kernel.org, starvik@axis.com,
       jesper.nilsson@axis.com, dhowells@redhat.com,
       ysato@users.sourceforge.jp, tony.luck@intel.com, takata@linux-m32r.org,
       geert@linux-m68k.org, monstr@monstr.eu, ralf@linux-mips.org,
       kyle@mcmartin.ca, benh@kernel.crashing.org, paulus@samba.org,
       heiko.carstens@de.ibm.com, lethal@linux-sh.org, davem@davemloft.net,
       jdike@addtoit.com, chris@zankel.net, rusty@rustcorp.com.au
Subject: Re: [PATCHSET core/percpu] percpu: convert most archs to dynamic
 percpu
Message-ID: <20090520104120.5742542e@skybase>
In-Reply-To: <1242805059-18338-1-git-send-email-tj@kernel.org>
References: <1242805059-18338-1-git-send-email-tj@kernel.org>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 May 2009 16:37:32 +0900
Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> Please do NOT pull before maintainers of alpha and s390 ack.  Upon
> ack, please pull from the following git tree.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu
> 
> This patchset is combination of the last patch of
> percpu-use-dynamic-percpu-allocator-as-default patchset[1] and patches
> inspired by alpha conversion patch[2] posted by Ivan Kokshaysky.
> 
>   0001-percpu-use-dynamic-percpu-allocator-as-the-default.patch
>   0002-linker-script-throw-away-.discard-section.patch
>   0003-percpu-clean-up-percpu-variable-definitions.patch
>   0004-percpu-enforce-global-uniqueness-and-disallow-in-fu.patch
>   0005-alpha-kill-unnecessary-__used-attribute-in-PER_CPU_.patch
>   0006-alpha-switch-to-dynamic-percpu-allocator.patch
>   0007-s390-switch-to-dynamic-percpu-allocator.patch
> 
> 0001 is mostly unchanged except for added Acked-by's.
> 
> 0002-0003 prepare for percpu variable definition update - .discard is
> thrown away on all archs when linking kernel and modules, static
> percpu variables in functions are moved outside of the function and
> all static percpu variables are given unique names.
> 
> 0004 updates percpu variable definition such that all percpu variables
> in the same link unit have unique names regardless of its scope
> (static or global) and disallow in-function static definitions.  The
> new definition uses dummy variables in .discard to enforce the
> declaration/definition semantics and always defines percpu variables
> as globals.  This allows archs to add 'weak' attribute if necessary.
> 
> 0005-0006 converts alpha to use 'weak' attribute instead of inline
> assembly to generate GOT based reference when referencing percpu
> variables from modules, which in turn allows conversion to dynamic
> percpu allocator.
> 
> 0007 does the same for s390.
> 
> The new DECLARE/DEFINE macros implement the following behaviors.
> 
> a. DECLARE + static DEFINE -> compile error
> 
> b. multiple non-static DEFINEs with the same name -> compile error
> 
> c. multiple static/global DEFINEs with the same name -> compile error
> 
> d. in function static DEFINEs -> compile error
> 
> #a and #b are expected behaviors on DECLARE/DEFINE macros in general.
> #c and #d are necessary to allow 'weak' attribute on certain archs.
> Please note that the rules are applied consistently whether 'weak'
> attribute is specified or not.  This eases catching mistakes and makes
> things less confusing.
> 
> Test config boots and works fine on x86_64.  alpha and s390 are
> compile tested and verified to generate necessary code for external
> references but I don't have any way to actually verify them, so please
> test them.  :-)
> 
> all-yes-config on x86_64 is building now.  Ergggh... I want more
> memory.  Okay, completed successfully.

Just tested the patch-series on s390. Works fine:
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

Kudos to Tejun and Ivan :-)

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

