Return-Path: <linux-kernel-owner+w=401wt.eu-S935502AbXHHTqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935502AbXHHTqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 15:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758802AbXHHTqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 15:46:00 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:24454 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883AbXHHTp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 15:45:59 -0400
Subject: Re: [PATCH -rt 9/9] seqlocks: use PICK_FUNCTION
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <20070806072153.GH5359@elte.hu>
References: <20070730024534.369897977@mvista.com>
	 <20070730024721.274774887@mvista.com>  <20070806072153.GH5359@elte.hu>
Content-Type: text/plain
Date: Wed, 08 Aug 2007 12:40:33 -0700
Message-Id: <1186602033.22044.67.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-06 at 09:21 +0200, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > Replace the old PICK_OP style macros with PICK_FUNCTION. Although, 
> > seqlocks has some alien code, which I also replaced as can be seen 
> > from the line count below.
> 
> ok, i very much like the cleanup effects here, could you resend your 
> latest version of this (with Peter's suggested cleanup) against -rc2-rt2 
> so that i can apply it?

Ok, sent them privately. Updated to 2.6.23-rc2-rt2 w/ Peter's
suggestion. You'll get two sets the first had some unrefreshed hunks in
the 3/3 patch .

There is one thing I was wondering about in seqlock.h . There was a
class of these macro's like below,

#define PICK_SEQOP_CONST_RET(op, lock)                          \
({                                                              \
        unsigned long __ret;                                    \
                                                                \
        if (TYPE_EQUAL((lock), raw_seqlock_t))                  \
                __ret = op##_raw((const raw_seqlock_t *)(lock));\
        else if (TYPE_EQUAL((lock), seqlock_t))                 \
                __ret = op((seqlock_t *)(lock));                \
        else __ret = __bad_seqlock_type();                      \
                                                                \
        __ret;                                                  \
})

Where the variable is specifically casted to "const raw_seqlock_t *".. I
ended up dropping these all together, and I'm wonder what the adverse
effects of that are .. The casting seems superfluous to me since you
know already that the type are compatible at that point. Any thoughts?

Daniel

