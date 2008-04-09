Return-Path: <linux-kernel-owner+w=401wt.eu-S1755421AbYDIQLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbYDIQLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 12:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbYDIQLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 12:11:43 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:41338 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbYDIQLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 12:11:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=g/9KFSnpzB8SsSlD8R35YyWA2aLl7eSFI3n3Ynh9qzkxP037G773nk+I8px29C+u7WeEEdHSZkTzfzVwk09p191Cc6hkQdq91JVobY7zJ5Xnlr0m6MJvfmwOeWvZ4zazTW857dIfdhkifpsor0SLxyg2elIYTzjRbwF/m04ScZg=
Date: Wed, 9 Apr 2008 12:11:25 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: benh@kernel.crashing.org, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: lockdep, false positive ?
Message-ID: <20080409120803.ZZRA012@mailhub.coreip.homeip.net>
References: <1207714607.9079.22.camel@pasglop> <1207734281.4110.46.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207734281.4110.46.camel@twins>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Wed, Apr 09, 2008 at 11:44:41AM +0200, Peter Zijlstra wrote:
> 
> Yes, if both locks are of the same class it will report this. Lockdep
> does lock chain validation on classes, never on individual locks.
> 
> A class usually consists of all locks that share the lock init site; but
> there are ways to explicity set another class.
> 
> In case of these recursions we have helpers like spin_lock_nested(&lock,
> subclass) that allow you to annotate these. These sub-classes must then
> always be taken in the same order; subclass < 8.
> 
> In this case its probably easier to explicity set a class, as the
> nesting is not exposed to the input layer, so it doesn't know about it.
> 

Is there a way in lockdep to mark all instances of a given lock as distinct?
I'd rather do that in input core once and be done with it.

Also another question I've been meaning to ask - we have lockdep annotations
in serio code and they work fine first time around but if you reload
psmouse module lockdep will barf if you have SYnaptics touchpad with
pass-through port. What gives?

-- 
Dmitry
