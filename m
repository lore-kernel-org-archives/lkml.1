Return-Path: <linux-kernel-owner+w=401wt.eu-S1761604AbXIKFTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761604AbXIKFTs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 01:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758629AbXIKFTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 01:19:40 -0400
Received: from ozlabs.org ([203.10.76.45]:48611 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758275AbXIKFTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 01:19:39 -0400
Subject: Re: [patch 1/8] Immediate Values - Global Modules List and Module
	Mutex
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20070911004541.GA4360@Krystal>
References: <20070906200228.086651361@polymtl.ca>
	 <20070906200314.079453533@polymtl.ca>
	 <20070908072811.GB1819@martell.zuzino.mipt.ru>
	 <1189468414.8023.66.camel@localhost.localdomain>
	 <20070911004541.GA4360@Krystal>
Content-Type: text/plain
Date: Tue, 11 Sep 2007 15:18:58 +1000
Message-Id: <1189487938.20631.53.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-10 at 20:45 -0400, Mathieu Desnoyers wrote:
> Code patching of _live_ SMP code is allowed. This is why I went through
> all this trouble on i386.

Oh, I was pretty sure it wasn't.  OK.

So now why three versions of immediate_set()?  And why are you using my
lock for exclusion?  Against what?

Why not just have one immediate_set() which iterates through and fixes
up all the references?  It can use an internal lock if you want to avoid
concurrent immediate_set() calls.

I understand the need for a "module_immediate_fixup()" but that can also
use your internal lock.

> > 2) immediate_if() needs an implementation before you introduce it.  Your
> > assumption that it's always unlikely seems non-orthogonal.
> 
> I could remove the unlikely(), no problem with that. Your point about
> this is valid. However, I would like to leave the immediate_if() there
> because it may become very useful if someday gcc permits to extract the
> address of a branch instruction (and to generate assembly that would not
> be reached without doing code patching).

Why is it easier to patch the sites now than later?  Currently it's just
churn.  You could go back and find them when this mythical patch gets
merged into this mythical future gcc version.  It could well need a
completely different macro style, like "cond_imm(var, code)".

Rusty.

