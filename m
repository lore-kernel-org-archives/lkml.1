Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbYJ3OxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbYJ3OxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 10:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754265AbYJ3OxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 10:53:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36883 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982AbYJ3OxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 10:53:09 -0400
Message-ID: <4909C9D9.7040105@zytor.com>
Date: Thu, 30 Oct 2008 07:51:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jike Song <albcamus@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix inline assembly constraints
References: <1225297937-2917-1-git-send-email-albcamus@gmail.com>	 <20081029163400.GA14866@elte.hu>	 <df9815e70810291931i4c00966u8f4493386e376b28@mail.gmail.com>	 <49093012.7010301@zytor.com> <df9815e70810292340g52d38e83t47dffd02125b4fe3@mail.gmail.com>
In-Reply-To: <df9815e70810292340g52d38e83t47dffd02125b4fe3@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jike Song wrote:
> 
> Yes, sometimes gcc did have bugs with its obscure inline asm
> conventions. But I think the change of x86-64 atomic operations should
> be OK. Anyway, the "+" constraint is more clear than a "=m" output and
>  a "m" input.
> 
> The 32-bit atomic ops were already changed to "+m".(commit
> b862f3b099f3ea672c7438c0b282ce8201d39dfc)
> 

You *THINK*.  It's very easy to *THINK* that gcc won't do something
utterly moronic, and you'd be wrong.

Just changing it for the sake of churn is pointless... if there is a
bug, then we have to take the risk anyway, but if it is already correct,
then there is no point in provoking a bug.  Not *your* bug, because your
code is correct, but gcc's bug.

FWIW, the reason that code doesn't use "+m" is because a version of gcc
which we no longer support didn't handle it.  That by itself isn't a
reason to keep it, but there is also no reason to just "tidy" it, IMNSHO.

	-hpa
