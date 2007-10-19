Return-Path: <linux-kernel-owner+w=401wt.eu-S966570AbXJSJMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966570AbXJSJMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 05:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbXJSJMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 05:12:07 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48892 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbXJSJME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 05:12:04 -0400
Date: Fri, 19 Oct 2007 12:12:03 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@kivilampi-30.cs.helsinki.fi
To: Ingo Molnar <mingo@elte.hu>
cc: Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: latest checkpatch
In-Reply-To: <20071018193929.GA22031@elte.hu>
Message-ID: <Pine.LNX.4.64.0710191157050.11079@kivilampi-30.cs.helsinki.fi>
References: <20071015182118.GA4459@shadowen.org>
 <200710161759.l9GHxnkK012590@agora.fsl.cs.sunysb.edu> <20071017163916.GO21136@shadowen.org>
 <20071018111352.GA17039@elte.hu> <20071018192521.GC21136@shadowen.org>
 <20071018193929.GA22031@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2007, Ingo Molnar wrote:

> 
> * Andy Whitcroft <apw@shadowen.org> wrote:
> 
> > > it's perfectly legitimate, in fact more robust. So if checkpatch.pl 
> > > wants to make any noise about such constructs it should warn about 
> > > the _lack_ of curly braces in every multi-line condition block 
> > > _except_ the only safe single-line statement:
> > > 
> > > 	if (x)
> > > 		y();
> > 
> > Indeed.  We should probabally do more on the indentation checks in
> > general.  The current direct check for:
> > 
> > 	if (foo);
> > 		bar();
> > 
> > Could probabally be generalised to look for this kind of error:
> > 
> > 	if (foo)
> > 		bar();
> > 		baz();
> > 	one();
> 
> detecting that would be awesome - it's often the sign of a real bug 
> because the intent is often to have bar() and baz() in the conditional 
> block.

Should probably detect these as well (if not yet being done):

	if (abc)
#if...
		def();
		ghi();
#e...


...plus this one:

	if (abc)
#if...
		def();
#endif
	ghi();

...Both of them are clearly bugs.

...and this where either indentation has to be fixed or the bug corrected:

	if (abc)
	def();


-- 
 i.
