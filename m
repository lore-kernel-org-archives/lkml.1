Return-Path: <linux-kernel-owner+w=401wt.eu-S1755624AbXFLL27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbXFLL27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 07:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbXFLL2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 07:28:50 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:10759 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbXFLL2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 07:28:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BzbySVu1OKnwYOWehXK1I7P1F0r88YOKeNt76oiuAL+q6k/hmnoIWtWp7XKgTcp5Vw0lUryHX9az6bX0GJWYWTj7XNjEA1Xi5uxL872mg58kB1grNVny9t8n78BqPSCtCDhVy/tSluGGXt4h8v/PftgNQUwSE2z+JecERqta0r4=
Message-ID: <a781481a0706120428t7869109fv766c9a655ccb51cc@mail.gmail.com>
Date: Tue, 12 Jun 2007 16:58:48 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [PATCH] fix improper .init-type section references
Cc: "Sam Ravnborg" <sam@ravnborg.org>, linux-kernel@vger.kernel.org
In-Reply-To: <a781481a0706120421l94f8d8dk864f288d63c01b1a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466E66AE.76E4.0078.0@novell.com>
	 <a781481a0706120242o5bcabee1ke67c96d5a7dd6cb0@mail.gmail.com>
	 <466E89EB.76E4.0078.0@novell.com>
	 <a781481a0706120421l94f8d8dk864f288d63c01b1a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/12/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> On 6/12/07, Jan Beulich <jbeulich@novell.com> wrote:
> [...]
> > >I believe the correct fix to silence modpost here would be to mark its
> > >caller kthreadd() also as __init, because it too is used only at init time?
> >
> > I don't think so - it is my understanding that this is the body of a thread
> > that never dies.
>
> Ugh, yes, I'm smoking God-knows-what, and you're absolutely correct!
>
> So we should be marking kthreadd() as __init_refok instead, it seems.

Actually, kthreadd_setup() is a 4-liner with only one callsite. Not much
point marking it as __init. In fact, does it even need to be a separate
function at all? We could just get rid of kthreadd_setup() and open-code
those 4 lines in kthreadd() itself ...
