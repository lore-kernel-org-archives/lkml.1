Return-Path: <linux-kernel-owner+w=401wt.eu-S932139AbYDBSnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139AbYDBSnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756152AbYDBSgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:36:17 -0400
Received: from relay1.sgi.com ([192.48.171.29]:40651 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759230AbYDBSgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:36:16 -0400
Date: Wed, 2 Apr 2008 11:33:42 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: dmitri.vorobiev@gmail.com, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc8-mm1 (mips build failure)
In-Reply-To: <20080402112907.76e1c554.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0804021130040.28113@schroedinger.engr.sgi.com>
References: <20080401213214.8fbb6d6b.akpm@linux-foundation.org>
 <47F31C46.9000503@gmail.com> <20080401230322.331c50f4.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0804021031480.26938@schroedinger.engr.sgi.com>
 <20080402112907.76e1c554.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008, Andrew Morton wrote:

> i386 generates
> 
> ->NR_PAGEFLAGS $18 __NR_PAGEFLAGS       #

> mips generates
> 
> ->NR_PAGEFLAGS 18 __NR_PAGEFLAGS         #

For some reason the asm-offset.c for mips generates it differently and the 
sed expression in kbuild is different. So it does not match.
 
> The only difference is the "$".  This can be trivially handled in the sed
> expression which filters this .s file.

Maybe the simple solution is to drop the strange mips way of doing things 
and clean up Kbuild in the process?

> Why are we diddling with that "->" thing, and why does it even exist?

I guess this is some convention to allow the Kbuild set script to extract 
the value. There must be some reason that they added the strange prefix.

ccing Sam who may shed some light on this.
