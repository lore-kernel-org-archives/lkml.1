Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbYKGSqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbYKGSqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 13:46:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbYKGSqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 13:46:25 -0500
Received: from smtp-out.google.com ([216.239.33.17]:51139 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbYKGSqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 13:46:24 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=nxM86TBYZSM9CTF39NUz4q6AFKTgLUDn98FB66A6sgxiJ8jKyNTpfbSg1QbDzSMEP
	9cm309tHTN/00EtOdtyhA==
MIME-Version: 1.0
In-Reply-To: <b040c32a0811071038g5e6faba6n55b22e52e1d2ea98@mail.gmail.com>
References: <20081106203520.GD3578@elte.hu> <20081107003021.GA18666@google.com>
	 <20081107004824.GA28780@x200.localdomain>
	 <20081107074147.GA26607@elte.hu> <20081107075925.GA1825@elte.hu>
	 <20081107082003.GA15800@x200.localdomain>
	 <20081107083249.GD4435@elte.hu>
	 <b040c32a0811071038g5e6faba6n55b22e52e1d2ea98@mail.gmail.com>
Date: Fri, 7 Nov 2008 10:46:11 -0800
Message-ID: <6599ad830811071046w30111c42refcc2287a154a1e@mail.gmail.com>
Subject: Re: [patch] add /proc/pid/stack to dump task's stack trace
From: Paul Menage <menage@google.com>
To: Ken Chen <kenchen@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 7, 2008 at 10:38 AM, Ken Chen <kenchen@google.com> wrote:
>
> Here is a patch convert to seq_file using proc_single_show() helper.
> I don't see it to be any superior than what was before using
> snprintf().  seq_read also allocate one page for printf buffer, so
> functionally it is the same (perhaps a little bit better because it
> can use the whole page, compare to PROC_BLOCK_SIZE currently).

No - if you exceed the original buffer size, the seq_file system will
double up the memory buffer and try again if necessary.

Paul
