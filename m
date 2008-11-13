Return-Path: <linux-kernel-owner+w=401wt.eu-S1752504AbYKMRBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbYKMRBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 12:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbYKMRBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 12:01:10 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:9922 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbYKMRBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 12:01:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=m+uUSgo2yQOSAgJm7pLvDKPrbvn1j9+NdA53Ho1tWHiT78ckBz7V4ry4kH09iTQmvI
         DRMIWpMtb0+zJkdEeT+w38Fk08yJH6nJ2TvjjJRCLBaH1aBfMxsmjPgYB8qo60G1lFhF
         pwNdi50NGSd659yDfU45yDUnfYgws/1Oa7GZY=
Message-ID: <c62985530811130901t7ddf84beof39a964582fb94a0@mail.gmail.com>
Date: Thu, 13 Nov 2008 18:01:08 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH 1/2] tracing/function-return-tracer: Make the function return tracer lockless
Cc: "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <87od0jd6ds.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <491B4F0A.3080901@gmail.com> <87od0jd6ds.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/13 Andi Kleen <andi@firstfloor.org>:
> The problem I think is that you assume the ++ is atomic against
> interrupts, which is not guaranteed by the C compiler. e.g.
> it would be perfectly legal for the compiler to generate code like
>
> local register i
> i = index;
> write to index'ed array using i
>                            <--------- interrupt here would overwrite data
> ...
> index = i + 1;


Yes in the common case that would be a danger. But here, if an
interrupt is raised, it will increment
the counter and then decrement it at return time without dropping the
cpu. So after the interrupt, the
value will remain the same...
