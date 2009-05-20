Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbZETIAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbZETIAK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 04:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755070AbZETH7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 03:59:52 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:11201 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643AbZETH7v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 03:59:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oCU9AsLa5hJJLGeytJXxaant0OSCd6uK6M3F8vs2B1XWchb2rR7xIv2pN7UEskqieI
         r7fAt+TJKuFo0jRuKFEjrgHEw1UrqM8h5sqmtjKdKEcbNtKvLo0mCyO7ieeECB/JHvDP
         Ymn1NJMYF0Rh1RM4BZ+nYjTk7f+N7dPyFpBHA=
MIME-Version: 1.0
In-Reply-To: <1242805059-18338-3-git-send-email-tj@kernel.org>
References: <1242805059-18338-1-git-send-email-tj@kernel.org>
	 <1242805059-18338-3-git-send-email-tj@kernel.org>
Date: Wed, 20 May 2009 03:59:50 -0400
Message-ID: <8bd0f97a0905200059pea3469do9e9b1a7644517558@mail.gmail.com>
Subject: Re: [PATCH 2/7] linker script: throw away .discard section
From: Mike Frysinger <vapier.adi@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, x86@kernel.org,
       ink@jurassic.park.msu.ru, rth@twiddle.net, linux@arm.linux.org.uk,
       hskinnemoen@atmel.com, cooloney@kernel.org, starvik@axis.com,
       jesper.nilsson@axis.com, dhowells@redhat.com,
       ysato@users.sourceforge.jp, tony.luck@intel.com, takata@linux-m32r.org,
       geert@linux-m68k.org, monstr@monstr.eu, ralf@linux-mips.org,
       kyle@mcmartin.ca, benh@kernel.crashing.org, paulus@samba.org,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, lethal@linux-sh.org,
       davem@davemloft.net, jdike@addtoit.com, chris@zankel.net,
       rusty@rustcorp.com.au
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 20, 2009 at 03:37, Tejun Heo wrote:
> x86 throws away .discard section but no other archs do.  Also,
> .discard is not thrown away while linking modules.  Make every arch
> and module linking throw it away.  This will be used to define dummy
> variables for percpu declarations and definitions.

seems like a good time to introduce a common DISCARD define to
include/asm-generic/vmlinux.lds.h.  considering multiple /DISCARD/
entries are allowed in a linker script, the define should be pretty
straightforward:
#define DISCARDS \
    /DISCARD/ : { \
        EXIT_TEXT \
        EXIT_DATA \
        *(.exitcall.exit) \
        *(.discard) \
    }
-mike
