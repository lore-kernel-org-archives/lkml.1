Return-Path: <linux-kernel-owner+w=401wt.eu-S1755159AbYGITNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbYGITNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 15:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335AbYGITN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 15:13:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48547 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750818AbYGITN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 15:13:28 -0400
Message-ID: <48750D96.7030407@linux-foundation.org>
Date: Wed, 09 Jul 2008 14:12:22 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <4874F4F2.9010603@goop.org> <4874F7D9.5060607@linux-foundation.org> <4874FD52.8070000@sgi.com> <4874FFC4.7050505@linux-foundation.org> <487502BD.2020206@goop.org> <487504A8.5040000@linux-foundation.org> <487507E7.6010102@goop.org> <48750945.8000201@linux-foundation.org> <48750C6C.5090606@goop.org>
In-Reply-To: <48750C6C.5090606@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:

> No, they don't help at all, because they convert X_pda(Y) (which doesn't
> exist) into x86_X_percpu(pda.Y) (which also doesn't exist).  They don't
> remove any #ifdef CONFIG_X86_64's.  If you're going to tromp all over
> the source, you may as well do the most useful thing in the first step.

Well they help in the sense that the patches get rid of the special X_pda(Y) operations. 
x86_X_percpu will then exist under 32 bit and 64 bit.

What is remaining is the task to rename 

	pda.Y -> Z

in order to make variable references the same under both arches. Presumably the Z is the corresponding 32 bit variable. There are likely a number of cases where the transformation
is trivial if we just identify the corresponding 32 bit equivalent.

