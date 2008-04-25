Return-Path: <linux-kernel-owner+w=401wt.eu-S1764785AbYDYR5C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764785AbYDYR5C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 13:57:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756852AbYDYR4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 13:56:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:51202 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbYDYR4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 13:56:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=b9Qd4mUBNSyoQoLUQ2tXRMVkt/OYMVAYNh5NdGtdtobDpoMB3ytSWamHa6M8gBMc3PJm8Hhjd2aO7uvFs6phn7B64Hhp0jaOE/3B3QRFw1ruNMFHo3ekh7H923316rX2yANd5gSKkIJEr0+tKeuiS0LThOR9RYkepmOwIkbFQoU=
Subject: Re: [PATCH] sched: add statics, don't return void expressions
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1209125826.24931.12.camel@lappy>
References: <1209086275.20088.4.camel@brick>
	 <1209125826.24931.12.camel@lappy>
Content-Type: text/plain
Date: Fri, 25 Apr 2008 10:56:51 -0700
Message-Id: <1209146211.20088.21.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-25 at 14:17 +0200, Peter Zijlstra wrote:
> On Thu, 2008-04-24 at 18:17 -0700, Harvey Harrison wrote:
> > Noticed by sparse:
> > kernel/sched.c:760:20: warning: symbol 'sched_feat_names' was not declared. Should it be static?
> > kernel/sched.c:767:5: warning: symbol 'sched_feat_open' was not declared. Should it be static?
> > kernel/sched_fair.c:845:3: warning: returning void-valued expression
> > kernel/sched.c:4386:3: warning: returning void-valued expression
> 
> I'm still of two minds about that latter warning, I think:
> 
> void foo(void);
> 
> void bar(void)
> {
> 	return foo();
> }
> 
> isn't wrong, as the return types match.
> 

True it's not wrong, but it is a trivial way to reduce the sparse noise
somewhat which can make it harder to see real bugs.  Just like the
integer used as NULL pointer warnings.

And even though in this case, I can't see the return type changing to
actually return something, coding it this way makes it obvious if you
ever missed a return site.

No strong feelings.

Harvey

