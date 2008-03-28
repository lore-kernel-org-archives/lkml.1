Return-Path: <linux-kernel-owner+w=401wt.eu-S1757069AbYC1UEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069AbYC1UEv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 16:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753787AbYC1UEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 16:04:43 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:46954 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753072AbYC1UEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 16:04:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=G5WhkhNJ0FFNWEggZMTR2StYntON7McToEHmYttMv1kZJXOqWxJ/7Mur2dEYI5jBLttjmL5/pcnZ+epW4DpVvAgB8zy4sn+j/Eot36OD0rBh5GMKGNCjRLIRTkSrv74IqGcX0NAKEhcO4ftL/MOVBLGbLH0Z8wbYAp3owR0uuUo=  ;
X-YMail-OSG: r3AGSskVM1kcgutLJYC7uq9zadgslefPN36OS6pZcJjG0gQZqsU_4DaJfvYEDP0vtLQUlgXZXg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Lord <lkml@rtr.ca>
Subject: Re: Kconfig RTC selection (was: 2.6.25-rc7: Ugh.)
Date: Fri, 28 Mar 2008 13:04:38 -0700
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, rtc-linux@googlegroups.com,
       David Miller <davem@davemloft.net>
References: <20080327160700.GB828@suse.de> <200803280249.42193.david-b@pacbell.net> <47ECF70A.2060600@rtr.ca>
In-Reply-To: <47ECF70A.2060600@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200803281304.39022.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ CC's trimmed a bit ]

On Friday 28 March 2008, Mark Lord wrote:
> > +# These legacy RTC drivers just cause too many conflicts with the generic
> > +# RTC framework ... let's not even try to coexist any more.
> ...
> 
> Thanks, David.  Could you perhaps also update the option descriptions
> to clearly indicate which set of RTCs are the new ones, and which are
> the old ones that are going away someday?

Hmm, I thought that would be clear from context.
"These" (drivers/char) legacy RTC drivers (old),
vs generic RTC framework (toplevel driver Kconfig).

Admittedly the *previous* Kconfig was troublesome,
at the UI level (vs. those comments outside the GUI).


A more general issue seems to be what to do with
those legacy RTC drivers.  Few of them seem to
have maintainers.  I don't want to own them, and
I doubt Alessandro does either.  If their Kconfig
is going to change, I'd rather just see them all
flagged as deprecated ... with plans to delete them.

The RTCs in question being:

  "RTC" ... replaced by new "rtc-cmos"
	--> ready to deprecate now ?

  "JS_RTC" ... a SPARC32 thing
	--> bug?? no "js-rtc.c" in the tree!  patch sent

  "SGI_DS1286" ... 
	--> needs conversion to new framework

  "SGI_IP27_RTC" ...
	--> needs conversion to new framework

  "GEN_RTC", "GEN_RTC_X" ... I never really saw the point
	--> who uses this?

  "EFI_RTC" ... IA64 only
	--> needs conversion to new framework

  "DS1302" ... M32R-specific, "rtc-ds1302" should replace it
	--> ready to deprecate now?

Plus there are various chunks of RTC code elsewhere in the tree,
mostly in arch subdirectories, which should be phased out but
aren't such obvious targets.


> I didn't find it at all obvious, and I still don't know which set my
> configured kernel is actually using.

If you enable the new framework, that's what it's
using; there should be no other options visible.
(At least, none that are even as loosely organized
as the drivers/char stuff.)

Else ... it's clearly not enabled!  So it's some
other (legacy) RTC driver.  I don't see the issue.

- Dave

