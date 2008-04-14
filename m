Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbYDNJDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbYDNJDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 05:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbYDNJDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 05:03:39 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:13097 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbYDNJDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 05:03:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=lFuhrgCe31BL9GDMGiUpPQrpIxChZKXOGdx6ZwPHkRSix0YoudLR361Y52ly19z7x9umk+8T6b0ZRpUL4MNGlz2SlfV+WaOoH0uoZ5baFDx0in6k4mY6xzls1lEUBNXja81TarBF8Jxvt2/CD5yaM7kzsgC5rdnqyvCutBeVho4=
Message-ID: <48031CF0.5060409@gmail.com>
Date: Mon, 14 Apr 2008 10:59:28 +0200
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: pgtable_32.h - prototype and section mismatch	fixes
References: <48022990.3060104@gmail.com> <20080414072645.GG16163@elte.hu> <20080414084127.GA11372@uranus.ravnborg.org> <20080414085307.GG19865@elte.hu>
In-Reply-To: <20080414085307.GG19865@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar pisze:
> * Sam Ravnborg <sam@ravnborg.org> wrote:
> 
>>> hm, that's an interesting case: we need those annotations probably 
>>> because gcc decided to not inline those functions. (this is possible 
>>> via the new CONFIG_OPTIMIZE_INLINING=y option) Sam, what's your take 
>>> on that?
>> gcc uses different heuristics for inlining between the different 
>> versions. Therefore to achieve somehow predictable results I added 
>> -fno-inline-functions-called-once when CONFIG_DEBUG_SECTION_MISMATCH 
>> is enabled.
>>
>> So in the above case for any normal kernel build we would see that gcc 
>> inlined the above and everything is fine. But for the 
>> CONFIG_DEBUG_SECTION_MISMTCH cases we do not inline and thus we see 
>> that we have a section mismatch.
> 
> ah, ok. So i guess this will result in a few isolated cases of __init 
> annotations added to inline functions - Jacek fixed one such case - but 
> it should not result in the general spreading of __init annotations to 
> inline functions, correct? (which i was worried about)
> 

Yep, I was confused about that patch, thus I didn't sent it previously.

Hmm...I forgot that all my kernels where compiled with
CONFIG_OPTIMIZE_INLINING=y. There's no mismatch warning printed while
OPTIMIZE_INLINING is not set. Also I've made a fast look into objects and looks
like those two functions are really inlined. I will also take a look on those
functions with CONFIG_OPTIMIZE_INLINING=y && ONFIG_DEBUG_SECTION_MISMATCH=n.

-Jacek
