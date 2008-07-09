Return-Path: <linux-kernel-owner+w=401wt.eu-S1754659AbYGIRkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbYGIRkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 13:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753051AbYGIRkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 13:40:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39821 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752870AbYGIRkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 13:40:14 -0400
Message-ID: <4874F7D9.5060607@linux-foundation.org>
Date: Wed, 09 Jul 2008 12:39:37 -0500
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
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <4874F4F2.9010603@goop.org>
In-Reply-To: <4874F4F2.9010603@goop.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:

> The bulk of this series is pda_X to x86_X_percpu conversion.  This seems
> like pointless churn to me; there's nothing inherently wrong with the
> pda_X interfaces, and doing this transformation doesn't get us any
> closer to unifying 32 and 64 bit.

What is the point of the pda_X interface? It does not exist on 32 bit.
The pda wastes the GS segment register on a small memory area. This patchset
makes the GS segment usable to reach all of the per cpu area by placing
the pda into the per cpu area. Thus the pda_X interface becomes obsolete
and the 32 bit per cpu stuff becomes usable under 64 bit unifying both
architectures.


> I think we should start devolving things out of the pda in the other
> direction: make a series where each patch takes a member of struct
> x8664_pda, converts it to a per-cpu variable (where possible, the same
> one that 32-bit uses), and updates all the references accordingly.  When
> the pda is as empty as it can be, we can look at removing the
> pda-specific interfaces.

This patchset places the whole x8664_pda structure into the per cpu area and makes the pda macros operate on the x8664_pda structure in the per cpu area. Not sure why you want to go through the churn of doing it for each object separately.

