Return-Path: <linux-kernel-owner+w=401wt.eu-S1754191AbYEKA6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbYEKA6V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 20:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbYEKA6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 20:58:03 -0400
Received: from ozlabs.org ([203.10.76.45]:38673 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757457AbYEKA5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 20:57:49 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3/3] module: don't ignore vermagic string if module doesn't have modversions
Date: Sun, 11 May 2008 10:57:34 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>
References: <200805091623.18127.rusty@rustcorp.com.au> <200805091625.28705.rusty@rustcorp.com.au> <alpine.LFD.1.10.0805090739240.3142@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805090739240.3142@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805111057.34790.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 May 2008 00:44:34 Linus Torvalds wrote:
> On Fri, 9 May 2008, Rusty Russell wrote:
> > We should only ignore the start of the vermagic string if the module
> > actually *has* crcs to check.  Rather than (say) having an
> > entertaining hissy fit and creating a config option to work around the
> > buggy code.
>
> Btw, this makes the two vesions of "same_magic()" be basically the same
> (since without MODVERSIONS, has_crcs *should* always be zero). Maybe we
> should make it just one version, to simplify logic?

I know, but it's a little subtle.

If the module has an __versions section, yet the kernel was built without 
CONFIG_MODVERSIONS, we should not ignore the first part of the version.  We 
could just #ifdef CONFIG_MODVERSIONS around the verindex initialization tho, 
to guarantee that it's 0 for !MODVERSIONS.  But that puts YA #ifdef in that 
function, and I already itch to clean up the ones there...

Cheers,
Rusty.
