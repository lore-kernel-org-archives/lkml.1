Return-Path: <linux-kernel-owner+w=401wt.eu-S1754391AbYAVVID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbYAVVID (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 16:08:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754560AbYAVVHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 16:07:52 -0500
Received: from nz-out-0506.google.com ([64.233.162.230]:4769 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605AbYAVVHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 16:07:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HpLF3ZbiaJ0zWYV+GAzDSpN1Ek8qeti5zCNryKx9zgVTeZi3nU1mYEoZYQM36H9mnYgCNHt5XAZBMqn4DcKwp02NOm94nNc+hBzmrKP0T+Gox9sCySv7OHuxxYafLI+BxYxUdzB9ZaeCytgIGixqQ9Acdr5G6GMhRl6sFSCR8Jc=
Subject: Re: [PATCH] x86: make nx_enabled conditional on CONFIG_X86_PAE
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ian Campbell <ijc@hellion.org.uk>,
       Mika =?ISO-8859-1?Q?Penttil=E4?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <1201035611.16972.61.camel@brick>
References: <1200758937-22386-2-git-send-email-ijc@hellion.org.uk>
	 <47939363.8040603@kolumbus.fi>
	 <1200950633.15491.21.camel@cthulhu.hellion.org.uk>
	 <479510CE.7010706@zytor.com>
	 <1200951996.15491.28.camel@cthulhu.hellion.org.uk>
	 <479551FD.5040801@zytor.com>
	 <1201023401.5643.52.camel@localhost.localdomain>
	 <479634A9.1090908@zytor.com>
	 <1201031325.15491.66.camel@cthulhu.hellion.org.uk>
	 <47964B7B.9000905@zytor.com>  <20080122203611.GA12892@elte.hu>
	 <1201035611.16972.61.camel@brick>
Content-Type: text/plain
Date: Tue, 22 Jan 2008 13:07:59 -0800
Message-Id: <1201036079.16972.65.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-01-22 at 13:00 -0800, Harvey Harrison wrote:
> nx_enabled can only be set to non-zero when CONFIG_X86_PAE is
> set.  The only use not currently inside a CONFIG_X86_PAE block
> is the definition, the declaration and a conditional unlikely
> test in fault_32.c (is_prefetch).
> 
> When !CONFIG_X86_PAE, is_prefetch always returns 0 immediately
> as nx_enabled is always 0.
> 
> When CONFIG_X86_PAE, the test is preserved, but the test against
> the cpu model and stepping is deleted, this may not be correct.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---

Sorry, I missed the usage in kernel/acpi/wakeup_32.S, that's the only
other user.  I don't know that code well enough to comment on the usage
there, but if anybody knows if that could be conditionalized, please
advise.


Harvey


