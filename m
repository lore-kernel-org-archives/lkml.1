Return-Path: <linux-kernel-owner+w=401wt.eu-S1757616AbZKJWVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616AbZKJWVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 17:21:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757529AbZKJWVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 17:21:50 -0500
Received: from 1wt.eu ([62.212.114.60]:50954 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757526AbZKJWVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 17:21:49 -0500
Date: Tue, 10 Nov 2009 23:21:40 +0100
From: Willy Tarreau <w@1wt.eu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pavel Machek <pavel@ucw.cz>, Avi Kivity <avi@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091110222140.GG26633@1wt.eu>
References: <20091110172454.3c4481f2@lxorguk.ukuu.org.uk> <4AF9B5AB.5010800@zytor.com> <4AF9C3EF.6000705@redhat.com> <4AF9C6AB.8080006@zytor.com> <20091110201602.GA26633@1wt.eu> <20091110205445.GB1407@ucw.cz> <20091110211259.GD26633@1wt.eu> <4AF9D8E2.7050205@zytor.com> <20091110220652.GE26633@1wt.eu> <4AF9E61B.5090407@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF9E61B.5090407@zytor.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 02:15:55PM -0800, H. Peter Anvin wrote:
> I immediately note that you have absolutely no check on the code
> segment, either in terms of code segment limits or even that we're in
> the right mode.  Furthermore, you read user space -- code in user space
> is still user space -- without get_user().

Yes I remember about that one now. HCH told me about it.

> We also need NX protection
> to be honoured, and the various special subtleties of the x86
> instruction format (15-byte limit, for example) to be preserved: they
> aren't just there randomly, but are there to protect against specific
> failures.

OK.

> *THIS* is the kind of complexity that makes me think that having a
> single source for all interpretation done in the kernel is the preferred
> option.

I understand, your point. We just need to check when it becomes overkill
to use a full-blown emulator of 3 instructions and a few "simple" rules.

Willy

