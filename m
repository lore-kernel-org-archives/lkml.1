Return-Path: <linux-kernel-owner+w=401wt.eu-S1756666AbYAORUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbYAORUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 12:20:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbYAORUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 12:20:43 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55978 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbYAORUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 12:20:42 -0500
Date: Tue, 15 Jan 2008 18:23:46 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: Folding _PAGE_PWT into _PAGE_PCD (was Re: unify pagetable accessors patch causes double fault II)
Message-ID: <20080115172346.GB2377@one.firstfloor.org>
References: <20080114094814.GA28300@basil.nowhere.org> <20080114125638.GA9510@basil.nowhere.org> <20080114130620.GA14057@elte.hu> <20080114135811.GA16190@one.firstfloor.org> <478BDC43.6050105@goop.org> <20080114222349.GA23409@one.firstfloor.org> <478BE628.7090008@goop.org> <20080115135317.GA13493@elte.hu> <478CEA82.9010606@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478CEA82.9010606@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> BTW, I just noticed that _PAGE_PWT has been folded into _PAGE_PCD.  This 
> seems like a really bad idea to me, since it breaks the rule that 
> _PAGE_X == 1 << _PAGE_BIT_X.  I can't think of a specific place where 
> this would cause problems, but this kind of non-uniformity always ends 
> up biting someone in the arse.

Agreed that it's a bad idea.

> 
> I think having a specific _PAGE_NOCACHE which combines these bits is a 
> better approach.

CPA series adds that already

+/* Needs special handling for large pages */
+#define _PAGE_CACHE     (_PAGE_PCD|_PAGE_PWT|_PAGE_PAT)
+

-Andi
