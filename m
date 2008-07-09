Return-Path: <linux-kernel-owner+w=401wt.eu-S1755094AbYGISOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbYGISOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 14:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbYGISOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 14:14:36 -0400
Received: from relay1.sgi.com ([192.48.171.29]:48943 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754806AbYGISOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 14:14:35 -0400
Message-ID: <4875000A.3060004@sgi.com>
Date: Wed, 09 Jul 2008 11:14:34 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Christoph Lameter <cl@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <4874F4F2.9010603@goop.org> <4874F7D9.5060607@linux-foundation.org> <4874FAB2.5080401@goop.org>
In-Reply-To: <4874FAB2.5080401@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
...
> 
> Once the pda has shrunk as much as it can (which remove everything
> except stack_canary, I think), then remove all the X_pda macros, since
> there won't be any users anyway.
> 
>    J

You bring up a good point here.  Since the stack_canary has to be 20
(or is that 0x20?) bytes from %gs, then it sounds like we'll still
need a pda struct of some sort.  And zero padding before that seems
counter-productive, so perhaps taking a poll of the most used pda
(or percpu) variables and keeping them in the same cache line would
be more useful?

Thanks,
Mike
