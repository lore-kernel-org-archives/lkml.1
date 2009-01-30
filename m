Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbZBCNKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbZBCNKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 08:10:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbZBCNKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 08:10:05 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50774 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348AbZBCNKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 08:10:04 -0500
Date: Fri, 30 Jan 2009 22:06:25 +0100
From: Pavel Machek <pavel@suse.cz>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Zachary Amsden <zach@vmware.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ian Campbell <Ian.Campbell@citrix.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC WIP] x86/paravirt: add register-saving thunks to
	reduce caller register pressure
Message-ID: <20090130210625.GD1253@ucw.cz>
References: <4980A07D.3010008@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4980A07D.3010008@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> This patch seeks to alleviate this pressure by introducing wrapper
> thunks that will do the register saving/restoring, so that the
> callsite doesn't need to worry about it, but the callee function can
> be conventional compiler-generated code.  In many cases (particularly
> performance-sensitive cases) the callee will be in assembler anyway,
> and need not use the compiler's calling convention.
>
> Standard calling convention is:
> 	 arguments	    return	scratch
> x86-32	 eax edx ecx	    eax		?

esi edi ebp ?

actually standard calling convention is all arguments on stack iirc
but we use regparm=3 for kernel...?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
