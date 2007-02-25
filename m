Return-Path: <linux-kernel-owner+w=401wt.eu-S965185AbXBYWkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965185AbXBYWkI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 17:40:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965191AbXBYWkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 17:40:08 -0500
Received: from ns1.suse.de ([195.135.220.2]:57526 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965185AbXBYWkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 17:40:06 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [PATCH 2.6.21-rc1] x86 signal number delivery fixes
Date: Sun, 25 Feb 2007 23:39:48 +0100
User-Agent: KMail/1.9.5
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
References: <200702251147.l1PBl9ab003231@harpo.it.uu.se>
In-Reply-To: <200702251147.l1PBl9ab003231@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702252339.48933.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 February 2007 12:47, Mikael Pettersson wrote:
> The invokation of signal handlers on x86 has several bugs
> in its treatment of the signal number parameter:
> 
> - the i386 kernel passes the raw not the translated signal number
>   in EAX to non-SA_SIGINFO handlers compiled with -mregparm=3;
>   the value passed on the stack is correct, and SA_SIGINFO handlers
>   are also invoked correctly
> - the x86-64 kernel's ia32 emulation for SA_SIGINFO handlers also
>   passes the wrong (untranslated) signal number in EAX; the value
>   on the stack is correct
> - the x86-64 kernel's ia32 emulation for non-SA_SIGINFO handlers
>   passes the wrong (untranslated) signal number both on the stack 
>   and in EAX


Nobody should be using that signal translation code anymore. Certainly
nothing in tree. Perhaps it would be better to just rip it out.

If you have a user you should submit it.

-Andi
