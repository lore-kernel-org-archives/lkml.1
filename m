Return-Path: <linux-kernel-owner+w=401wt.eu-S1752448AbXJ3Mac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbXJ3Mac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 08:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbXJ3MaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 08:30:23 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:38697 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbXJ3MaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 08:30:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Received:Message-ID:In-Reply-To:References:Date:Subject:From:To:Cc:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:Importance;
	b=Ap79c27eOJRGznuFyDK3ybeVClsUDfEitm4g+5eGt6j69g4dI5+kGSbhX2UcYJbNujGqFZbKzKT5b/yS8OlEOEmkNmjXtpuHGr58wyolafmdHZac4o4PzedIR/N4i+ij;
Message-ID: <29685.simon.1193747418@5ec7c279.invalid>
In-Reply-To: <4726D9D9.2000909@ii.net>
References: <10965.80.126.27.205.1193684677.squirrel@webmail.xs4all.nl>
    <4726377A.4080807@crispincowan.com>
    <e7d8f83e0710292213h4cf9cddw6e373d60fbab41f9@mail.gmail.com>
    <4726D9D9.2000909@ii.net>
Date: Tue, 30 Oct 2007 12:30:18 -0000
Subject: Re: Defense in depth: LSM *modules*, not a static interface
From: "Simon Arlott" <simon@fire.lp0.eu>
To: "Cliffe" <cliffe@ii.net>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
User-Agent: SquirrelMail/1.4.10a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, October 30, 2007 07:14, Cliffe wrote:
> And while I acknowledge that many of these layers are currently buried
> within the kernel (netfilter...) they are security layers which in many
> cases would probably make sense as stackable security modules.
>
> Making the interface static forces mammoth solutions which then must
> attempt to solve all of the above in one ls*m*. What happened to
> dividing tasks into easy to manage chunks?

Would it be possible to have Kconfig select which LSM should handle each
area of security? Selecting LSM A would automatically disable LSM B and
C since they both implement the same security functions, while LSM D
would still be selectable since it implements something else. The default
capabilities code would then turn off parts of itself that another LSM
is handling.

Alternatively the M in LSM can be restored and modules can be stacked.
It should be possible for the primary LSM to check the security_ops of the
secondary LSM(s) and complain if it considers there to be an incompatiblity.

-- 
Simon Arlott
