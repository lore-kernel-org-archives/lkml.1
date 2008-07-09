Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbYGISXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbYGISXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 14:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbYGISXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 14:23:17 -0400
Received: from gw.goop.org ([64.81.55.164]:37059 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870AbYGISXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 14:23:17 -0400
Message-ID: <48750202.3060603@goop.org>
Date: Wed, 09 Jul 2008 11:22:58 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Christoph Lameter <cl@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <4874F4F2.9010603@goop.org> <4874F7D9.5060607@linux-foundation.org> <4874FAB2.5080401@goop.org> <4875000A.3060004@sgi.com>
In-Reply-To: <4875000A.3060004@sgi.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Jeremy Fitzhardinge wrote:
> ...
>   
>> Once the pda has shrunk as much as it can (which remove everything
>> except stack_canary, I think), then remove all the X_pda macros, since
>> there won't be any users anyway.
>>
>>    J
>>     
>
> You bring up a good point here.  Since the stack_canary has to be 20
> (or is that 0x20?) bytes from %gs, then it sounds like we'll still
> need a pda struct of some sort.  And zero padding before that seems
> counter-productive, so perhaps taking a poll of the most used pda
> (or percpu) variables and keeping them in the same cache line would
> be more useful?

The offset is 40 (decimal).  I don't see any particular problem with 
putting zero padding in there; we can get rid of it if 
CONFIG_STACK_PROTECTOR is off.

The trouble with reusing the space is that it's going to be things like 
"current" which are the best candidates for going there - but if you do 
that you lose i386 unification (unless you play some tricks where you 
arrange to make the percpu variables land there while still appearing to 
be normal percpu vars).

    J
