Return-Path: <linux-kernel-owner+w=401wt.eu-S1754994AbYGIS1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994AbYGIS1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 14:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbYGIS1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 14:27:09 -0400
Received: from relay1.sgi.com ([192.48.171.29]:58541 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751582AbYGIS1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 14:27:08 -0400
Message-ID: <487502FB.3090106@sgi.com>
Date: Wed, 09 Jul 2008 11:27:07 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <4874F4F2.9010603@goop.org> <4874F7D9.5060607@linux-foundation.org> <4874FD52.8070000@sgi.com> <4874FFC4.7050505@linux-foundation.org>
In-Reply-To: <4874FFC4.7050505@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> Mike Travis wrote:
> 
>> I think Jeremy's point is that by removing the pda struct entirely, the
>> references to the fields can be the same for both x86_32 and x86_64.
> 
> That is going to be difficult. The GS register is tied up for the pda area
> as long as you have it. And you cannot get rid of the pda because of the library
> compatibility issues. We would break binary compatibility if we would get rid of the pda.
> 
> If one attempts to remove one field after another then the converted accesses will not be able to use GS relative accesses anymore. This can lead to all sorts of complications.
> 
> It will be possible to shrink the pda (as long as we maintain the fields that glibc needs) after this patchset because the pda and the per cpu area can both be reached with the GS register. So (apart from undiscovered surprises) the generated code is the same.

Is there a comprehensive list of these library accesses to variables
offset from %gs, or is it only the "stack_canary"?

Thanks,
Mike
