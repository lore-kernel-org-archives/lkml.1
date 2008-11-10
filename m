Return-Path: <linux-kernel-owner+w=401wt.eu-S1754931AbYKJSHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931AbYKJSHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 13:07:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754163AbYKJSHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 13:07:01 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:17646 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097AbYKJSHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 13:07:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MBKXaS7FbCdVcA4WRhllOXOToYhLZ49qkHT7OBLaWRtukrUfiNBYvlAsV4FQifpdsx
         lmmTTfNAPhnDHx/P5LkvCMjuWtdvZzbk+9TG4PCZmlHgKz6zFpbaiIVyW09SV9N+jpG5
         yYMGSRgyumC0TEn1VOR5IzcLqrmEkLbGxrm2A=
Message-ID: <e2e108260811101006s1a69d9e1rc7acf76373d79b57@mail.gmail.com>
Date: Mon, 10 Nov 2008 19:06:57 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [PATCH][RESEND] C99 initializers for DEFINE_RATELIMIT_STATE()
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Dave Young" <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.0811100932500.3468@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200811042114.48495.bart.vanassche@gmail.com>
	 <e2e108260811100443j18a6353cj8d47ee3f1f8bec1@mail.gmail.com>
	 <20081110091602.d5709c12.randy.dunlap@oracle.com>
	 <20081110093026.fe4bf90e.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.0811100932500.3468@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2008 at 6:34 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, 10 Nov 2008, Andrew Morton wrote:
>>
>> I already have a patch queued which does this
>> (linux-ratelimith-fixed-missing-initializer-warning.patch).  I sent it
>> to Linus on October 29 and he did not apply it, so I parked it for 2.6.29.
>
> I just don't see the point of the patch at all. It doesn't fix anything,
> and it just makes the code bigger and uglier. We have tons of other
> simple initializers that aren't C99, and we're not going to convert them
> either.

The current version of the header file include/linux/ratelimit.h
triggers false positives when the compiler flag
-Wmissing-field-initializers is specified. The header file
include/linux/ratelimit.h is included directly or indirectly by many
other header files -- inclusion of this file can't be avoided. The
above patch suppresses these false positives by converting the
initializers to C99 style, such that kernel developers who want to
check their code through -Wmissing-field-initializers can use this
compiler flag.  And I do not have plans to send patches for converting
initializers to C99-style for any .c file.

Bart.
