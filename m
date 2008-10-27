Return-Path: <linux-kernel-owner+w=401wt.eu-S1752702AbYJ0Ri0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbYJ0Ri0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 13:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbYJ0RiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 13:38:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:51930 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbYJ0RiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 13:38:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=mBp+iMzC6htzj+/AIvcdw8AZl8HFkrzecpnbynLUrSBlFumK+J5rHEyGCDbGav6eif
         zyEoaaeNKa2iCiUObNDMnoHPu/Aauhk6Vrpw458/AkThsuAxVXP0HJEscTBCx9KfWgLD
         Vi87aOKgLPjpv9l9vH2zLXYPYtpjLmzQAPJEU=
Message-ID: <8bd0f97a0810271038g4f0b7326r68c7e88841d0e6f9@mail.gmail.com>
Date: Mon, 27 Oct 2008 13:38:16 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Jan Kratochvil" <jan.kratochvil@redhat.com>
Subject: Re: inconsistent behavior with ptrace(TRACEME) and fork/exec
Cc: "Mike Frysinger" <vapier@gentoo.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20081027145648.GA15791@host0.dyn.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081027145648.GA15791@host0.dyn.jankratochvil.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2008 at 10:56, Jan Kratochvil wrote:
> On Wed, 19 Jul 2006 21:18:29 +0200, Mike Frysinger wrote:
>> my understanding is that if a parent forks and the child does
>> a ptrace(TRACEME) right before doing an exec(), the kernel should always
>> halt it and wait indefinitely for the parent to start ptracing it.
>
> Yes, just the parent must process the event (signal).  In your testcase the
> parent finished before the signal could be delivered.  If the tracer exits the
> tracee's tracing is finished and it continues freely.

no signal should have been generated.  the child should have gone
straight to the exec and waited for the parent to process it.

>> unfortunately, this behavior seems to be unreliable.
>
> Fixed the races in your code and I do not see there any problem, do you?
> The ptrace problems/testsuite is being maintained at:
>  http://sourceware.org/systemtap/wiki/utrace/tests

there is no race condition ... it's using vfork here remember ?  it is
impossible for the parent to have executed anything after the vfork()
before the child made it into the exec() and gone to sleep
-mike
