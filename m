Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813AbYGITHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbYGITHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 15:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbYGITHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 15:07:42 -0400
Received: from gw.goop.org ([64.81.55.164]:60105 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbYGITHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 15:07:42 -0400
Message-ID: <48750C6C.5090606@goop.org>
Date: Wed, 09 Jul 2008 12:07:24 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <4874F4F2.9010603@goop.org> <4874F7D9.5060607@linux-foundation.org> <4874FD52.8070000@sgi.com> <4874FFC4.7050505@linux-foundation.org> <487502BD.2020206@goop.org> <487504A8.5040000@linux-foundation.org> <487507E7.6010102@goop.org> <48750945.8000201@linux-foundation.org>
In-Reply-To: <48750945.8000201@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> Well yes I agree these could be better if the fields would be moved out of the pda
> structure itself but then it wont be mechanical anymore and require more
> review.

Yes, but they'll have more value.  And if you do it as one variable per 
patch, then it should be easy to bisect should any problems arise.

>  But these are an important step because they allow us to get rid of the
> pda operations that do not exist for 32 bit.
>   

No, they don't help at all, because they convert X_pda(Y) (which doesn't 
exist) into x86_X_percpu(pda.Y) (which also doesn't exist).  They don't 
remove any #ifdef CONFIG_X86_64's.  If you're going to tromp all over 
the source, you may as well do the most useful thing in the first step.

    J
