Return-Path: <linux-kernel-owner+w=401wt.eu-S1756970AbXJYAe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970AbXJYAe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 20:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbXJYAeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 20:34:20 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:57863 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbXJYAeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 20:34:19 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: vgoyal@in.ibm.com, hbabu@us.ibm.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH 1/3] x86: add lapic_shutdown for x86_64
References: <47195763.1090803@ct.jp.nec.com> <47195807.6030809@ct.jp.nec.com>
	<20071024062933.GA4622@in.ibm.com> <471FB8D2.5060208@ct.jp.nec.com>
Date: Wed, 24 Oct 2007 18:28:15 -0600
In-Reply-To: <471FB8D2.5060208@ct.jp.nec.com> (Hiroshi Shimamoto's message of
	"Wed, 24 Oct 2007 14:27:46 -0700")
Message-ID: <m1odeo6ns0.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> writes:

>> Do we really have to introduce this function for 64bit? I remember some
>> issues were faced on i386 w.r.t kernel enabling the LAPIC against the
>> wishes of BIOS hence kernel was disabling it while shutting down. No
>> such problems were reported for x86_64 hence this function existed only
>> for i386.
>
> Thanks for the comment. I didn't know the issues, so I'd simply added
> this function for unification.
>
>> If that is the case, probably we don't have to introduce lapic_shutdown()
>> for x86_64. Instead call lapic_shutdown() for X86_32, and disble_local_APIC()
>> otherwise?
>
> I will do that. I was thinking which is good when posting these patches.

I'm a little concerned here.  This sounds like forced unification.
If we can't clean up the infrastructure so things are obviously better
and cleanly factored for both architectures we should not unify the files.

As a general principle I would rather have two crudy files side by
side the one super crudy file.

So for unification I suggest finally fixing this right and taking the
apics completely out of the kexec on panic path.

Eric
