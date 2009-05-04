Return-Path: <linux-kernel-owner+w=401wt.eu-S932220AbZEDR0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220AbZEDR0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 13:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757191AbZEDR0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 13:26:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47087 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757181AbZEDR0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 13:26:30 -0400
Message-ID: <49FF24F8.5050008@zytor.com>
Date: Mon, 04 May 2009 10:25:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: akpm@linux-foundation.org, greg@kroah.com, mingo@elte.hu,
       tglx@linutronix.de, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 01/21] x86: add methods for writing of an MSR on	several
 CPUs
References: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com> <1241024107-14535-2-git-send-email-borislav.petkov@amd.com> <49F890D0.7000109@zytor.com> <20090504164614.GA21710@aftab>
In-Reply-To: <20090504164614.GA21710@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
>>
>> Please, for the love of God, no!
>>
>> Make it an array of u64s or (equivalently!) an array of (l,h)
>> structures, not separate arrays for the halves of the register.
> 
> how about something like the following then? If there's agreement I could
> convert all users to struct msr later.
> 

I personally would prefer if you just used an array of u64s.  The whole
l/h split for MSRs was a mistake in the first place.  However, if not,
at least make it a union; using something like:

union msr {
	u32 l[2];
	u64 q;
};

Or fancier, using gcc's anonymous structs/unions:

struct msr {
	union {
		struct {
			u32 l, h;
		};
		u64 q;
	};
};

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

