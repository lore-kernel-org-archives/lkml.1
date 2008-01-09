Return-Path: <linux-kernel-owner+w=401wt.eu-S1756005AbYAIV7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbYAIV7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 16:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbYAIV7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 16:59:17 -0500
Received: from ozlabs.org ([203.10.76.45]:36931 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383AbYAIV7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 16:59:16 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paulo Marques <pmarques@grupopie.com>
Subject: Re: [PATCH] call sysrq_timer_list_show from a workqueue
Date: Thu, 10 Jan 2008 08:58:47 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu, kyle@mcmartin.ca,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com
References: <20080108063113.GA21287@fattire.cabal.ca> <200801091420.19273.rusty@rustcorp.com.au> <4784E738.3070202@grupopie.com>
In-Reply-To: <4784E738.3070202@grupopie.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801100858.48292.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 January 2008 02:24:40 Paulo Marques wrote:
> Rusty Russell wrote:
> > Or better, rework all the name lookup interfaces, rather than having:
>
> Yes, there is some rework we can do here....

Hi Paulo,

	Yes, it just needs some thought...

> > extern int sprint_symbol(char *buffer, unsigned long address);
> > extern void __print_symbol(const char *fmt, unsigned long address);
>
> These 2 are probably fine.

Except they're awful for the !CONFIG_KALLSYMS case.  You really want something 
that that prints the name if available and the address otherwise.

> I can do a patch for this, but this will touch a few subsystems that use
> these interfaces (there are not a lot of them, though). The major change
> would probably be the allocation of a small buffer (56~60 bytes) in some
> of the callers to hold the module name.

Indeed.

I look forward to your patch!
Rusty.
