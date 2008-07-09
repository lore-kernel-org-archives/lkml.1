Return-Path: <linux-kernel-owner+w=401wt.eu-S1755467AbYGIWCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbYGIWCO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 18:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbYGIWB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 18:01:59 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:48281 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbYGIWB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 18:01:58 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Mike Travis <travis@sgi.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>
	<m1abgqzv3g.fsf@frodo.ebiederm.org> <4875301D.20805@sgi.com>
Date: Wed, 09 Jul 2008 14:55:29 -0700
In-Reply-To: <4875301D.20805@sgi.com> (Mike Travis's message of "Wed, 09 Jul
	2008 14:39:41 -0700")
Message-ID: <m1prpmsoxa.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Mike Travis <travis@sgi.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0028]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis <travis@sgi.com> writes:

> Hi Eric,
>
> There is one pda op that I was not able to remove.  Most likely it can be
> recoded
> but it was a bit over my expertise.  Most likely the "pda_offset(field)" can be
> replaced with "per_cpu_var(field)" [per_cpu__##field], but for
> "_proxy_pda.field"
> I wasn't sure about.

If you notice we never use %1.  My reading would be we just have the +m
there to tell the compiler we may be changing the field.  So just
a reference to the per_cpu_var directly should be sufficient.  Although
"memory" may actually be enough.

Eric
