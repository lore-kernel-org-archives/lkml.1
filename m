Return-Path: <linux-kernel-owner+w=401wt.eu-S1752798AbZGTVA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbZGTVA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 17:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbZGTVAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 17:00:25 -0400
Received: from web50109.mail.re2.yahoo.com ([206.190.38.37]:40356 "HELO
	web50109.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750907AbZGTVAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 17:00:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=ExNfiYNh6d7dK7KT6gQ4sPF2512fZ/sVKFOCRa815t15kZjqRyaMemH1aPWrr+29NxLJPjtRaueoNB5dR+HAoTDGVndRiW3jO7AOC6xcLlMI9BogmcCz0y94p1Eph3vW1WYsXg41dKDJiNqswkP/GqxkiKQlqMN+F4G7DNjV8+4=;
Message-ID: <508487.35908.qm@web50109.mail.re2.yahoo.com>
X-YMail-OSG: qIORz_kVM1nCblAcHQMHLyVXrPlTU.8mzqFQI1BWZOqM.Mu.dARWbrHNWefiOcQh9HiNcxEN4zkxlnW5GUwZcUxScvIao6.1nyRKvDxWf_JfG1JxMiiTX5e2gHu_0QODY9PA9hy0dEtpvtwQIk7sjq8aQU8KGJAYk1rWzZs261v2i.zY5VJ9ld.iBynSXAssZt__jxecS7qJbSVviNAV8ZvB0uy0p5wQJ3yo1enGhQBXfc7aq5BwdA4ah4k8BgN0Ocu1uarfBeYPHHBZWWsROoPYtpQQ34CDth1lK5X4X7m4lS33dqhb2mkM
X-Mailer: YahooMailClassic/6.0.18 YahooMailWebService/0.7.338.1
Date: Mon, 20 Jul 2009 14:00:23 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH 07/14] mce3: pass mce info to EDAC for decoding
To: Andi Kleen <andi@firstfloor.org>
Cc: Borislav Petkov <borislav.petkov@amd.com>,
       Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, aris@redhat.com, linux-kernel@vger.kernel.org,
       x86@kernel.org
In-Reply-To: <20090720192229.GC16072@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Mon, 7/20/09, Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <andi@firstfloor.org>
> Subject: Re: [PATCH 07/14] mce3: pass mce info to EDAC for decoding
> To: "Doug Thompson" <norsk5@yahoo.com>
> Cc: "Borislav Petkov" <borislav.petkov@amd.com>, "Andi Kleen" <andi@firstfloor.org>, mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, aris@redhat.com, linux-kernel@vger.kernel.org, x86@kernel.org
> Date: Monday, July 20, 2009, 1:22 PM
> > The goal is to have a default
> handler within the kernel and a more specific handler in a
> module after it has loaded. Using the weak symbol as a
> mechanism to do that. I haven't used that, so I don't know
> if it works.
> 
> weak symbols don't work over kernel modules.
> 
> -Andi

ok, thanks. That is one thing I was questioning. Unloading the module and the "fixup" was and what the dynamic linker did is the item I had doubts on. Bottom line: It does not re-fix it back to the original.

Boris, we need to change that.

edac_stub.c is a stub section of code that resides IN the kernel at all times (unless EDAC is disabled) and is a vector point currently used for some information.

My inclination was to add to that file for the jump from MCE to EDAC module space.

My initial code was to place a function in there to call and have MCE always call it.  Then have a registration api that the EDAC Module would call to register a callback routine.

When EDAC is disabled, then the function call from MCE became a macro that was reduced to an empty string.

doug t

> 
> -- 
> ak@linux.intel.com
> -- Speaking for myself only.
> 
