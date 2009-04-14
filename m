Return-Path: <linux-kernel-owner+w=401wt.eu-S1757215AbZDNQqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215AbZDNQqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754472AbZDNQqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:46:12 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:35347 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756520AbZDNQqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:46:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FaYGsLz92tuRDEggybWAOggAPS7hayw9pHiRLeRaoGduetOziHQkUMHtXXKDTnKT1Z
         lUuq+huWR/fi0txEnaM7R913YdlOG/Vzxk0TxzNw0ME1ijoljlWs9s/QligOxXCKiU5U
         If/TFblSdbipo40FzGQaFwMWJOk8kHmwXOQOs=
Date: Tue, 14 Apr 2009 20:46:23 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: containers@lists.osdl.org, Dave Hansen <dave@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Creating tasks on restart: userspace vs kernel
Message-ID: <20090414164623.GF27461@x200.localdomain>
References: <49E40662.2040508@cs.columbia.edu> <20090414163633.GE27461@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414163633.GE27461@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1) somebody should write registers before final jump to userspace.
>    Task itself can't generally do it: struct pt_regs is in the same place
>    as kernel stack.
> 
>    cr_load_cpu_regs() does exactly this: as current writes to it's own
>    pt_regs. Oren, why don't you see crashes?
> 
>    I first tried to do it and was greeted with horrible crashes because
>    e.g current becoming NULL under current. That's why 
>    cr_arch_restore_task_struct() is not done in current context.

Hmm, this must an artefact of kernel_thread() approach.
