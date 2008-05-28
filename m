Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbYE1UAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbYE1UAc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 16:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228AbYE1UAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 16:00:19 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51311 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306AbYE1UAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 16:00:18 -0400
Date: Wed, 28 May 2008 22:00:57 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Steve French <smfrench@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: optimizing out inline functions
Message-ID: <20080528200057.GA7300@uranus.ravnborg.org>
References: <524f69650805281251r1b1d99a1tc3223d15e3aeb50c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524f69650805281251r1b1d99a1tc3223d15e3aeb50c@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2008 at 02:51:02PM -0500, Steve French wrote:
> In trying to remove some macros, I ran across another kernel style
> question.  I see two ways that people try to let the compiler optimize
> out unused code and would like to know which is preferred.  The first
> example uses an empty inline function and trusts the compiler will
> optimize it out.
> 
> #ifdef CONFIG_DEBUG_SOMETHING
> static inline void some_debug_function(var1)
> {
>     something = var1;
>     printk(some debug text);
> }
> #else
> static inline void some_debug_function(var1)
> {
>    /* empty function */
> }
> #endif

With reference to a recent thread about kconfig
I would prefer:
static inline void some_debug_function(var1)
{
	if (KCONFIG_DEBUG_SOMETHING) {
		something = var1;
		printk(some debug text);
	}
}


But we do not have KCONFIG_DEBUG_SOMETHING available
so the second best is to use an empty function
to keep the typechecking in place.

IIRC gcc optimize both away.

	Sam
