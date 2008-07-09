Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084AbYGITcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbYGITcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 15:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbYGITce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 15:32:34 -0400
Received: from gw.goop.org ([64.81.55.164]:41750 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbYGITcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 15:32:33 -0400
Message-ID: <4875123F.1070504@goop.org>
Date: Wed, 09 Jul 2008 12:32:15 -0700
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
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <4874F4F2.9010603@goop.org> <4874F7D9.5060607@linux-foundation.org> <4874FD52.8070000@sgi.com> <4874FFC4.7050505@linux-foundation.org> <487502BD.2020206@goop.org> <487504A8.5040000@linux-foundation.org> <487507E7.6010102@goop.org> <48750945.8000201@linux-foundation.org> <48750C6C.5090606@goop.org> <48750D96.7030407@linux-foundation.org>
In-Reply-To: <48750D96.7030407@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> Well they help in the sense that the patches get rid of the special X_pda(Y) operations. 
> x86_X_percpu will then exist under 32 bit and 64 bit.
>
> What is remaining is the task to rename 
>
> 	pda.Y -> Z
>
> in order to make variable references the same under both arches. Presumably the Z is the corresponding 32 bit variable. There are likely a number of cases where the transformation
> is trivial if we just identify the corresponding 32 bit equivalent.
>   

Yes, I understand that, but it's still pointless churn.  The 
intermediate step is no improvement over what was there before, and 
isn't any closer to the desired final result.

Once you've made the pda a percpu variable, and redefined all the X_pda 
macros in terms of x86_X_percpu, then there's no need to touch all the 
usage sites until you're *actually* going to unify something.  Touching 
them all just because you find "X_pda" unsightly doesn't help anyone.  
Ideally every site you touch will remove a #ifdef CONFIG_X86_64, or make 
two as-yet unified pieces of code closer to unification.

    J
