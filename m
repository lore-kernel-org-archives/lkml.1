Return-Path: <linux-kernel-owner+w=401wt.eu-S1757315AbZCDSER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbZCDSER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 13:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753603AbZCDSEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 13:04:05 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:40109 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbZCDSEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 13:04:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nmaB1HHHZOX3cYrMjTmY1Ym3CaSxFXsqhxszFtuKpGpBVrSMVsxFWO98zD8/VJDn/g
         u+MURR+CxynoskWbbWbslWx54CrRVbQNBLmzLSITkP3ZKYV2+DpE6I8gYqE6oM0aBBxN
         7QnofJC2XRcVrewz9ZLDxfW50ektzQ09B2wT4=
MIME-Version: 1.0
In-Reply-To: <E1LerUo-0000NE-Q3@mailer.emlix.com>
References: <E1LerUo-0000NE-Q3@mailer.emlix.com>
Date: Wed, 4 Mar 2009 13:04:00 -0500
Message-ID: <8bd0f97a0903041004g467cbe47jc7c66261da01348c@mail.gmail.com>
Subject: Re: [patch -v2] flat: fix data sections alignment
From: Mike Frysinger <vapier.adi@gmail.com>
To: Johannes Weiner <jw@emlix.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       Russell King <rmk@arm.linux.org.uk>, Bryan Wu <cooloney@kernel.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Paul Mundt <lethal@linux-sh.org>, Greg Ungerer <gerg@uclinux.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 4, 2009 at 08:51, Johannes Weiner wrote:
> The flat loader uses an architecture's flat_stack_align() to align the
> stack but assumes word-alignment is enough for the data sections.
>
> However, on the Xtensa S6000 we have registers up to 128bit width
> which can be used from userspace and therefor need userspace stack and
> data-section alignment of at least this size.

could this perhaps be a gcc problem ?  x86 has a similar problem with
sse and they addressed it with a function attribute.  after all, just
because your stack started out 128bit aligned doesnt mean gcc will
keep it that way when calling other functions.  so having the stack
start out aligned would only "fix" the stack for the application's
entry point right (which would in practice bubble up to main()) ?  so
you'd be right back where you started ...
-mike
