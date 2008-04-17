Return-Path: <linux-kernel-owner+w=401wt.eu-S1763861AbYDQSDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763861AbYDQSDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 14:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763020AbYDQSDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 14:03:09 -0400
Received: from web52504.mail.re2.yahoo.com ([206.190.48.187]:32311 "HELO
	web52504.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762928AbYDQSDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 14:03:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=IUpRg6I1mZLBBij/RA4zYTzXUDU4LSWyP7LgoWMHVyejk6EqjYE7iHN3CGtmJvhaJnk+65EsOb9SDqW/yBt41PuQSYcf3NK9z4hCJvQW7A8VukNqnn0CWqxVAAxBHYEJjLVt1LZShrA9RtF0YX+t4UrzsJPC/GlIe5IYZH2T1lU=;
X-YMail-OSG: sEA.FxUVM1lvKtc1XQMZuIu5EUoeYC9vM7729mJkWoWMX6tB9FcmSMWQ75YOVx4OZQ--
Date: Thu, 17 Apr 2008 11:03:04 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: AMD Quad Core clock problem?
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <e2e108260804162317s5162a6cds151bba6abf988921@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <298557.12633.qm@web52504.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Bart Van Assche <bart.vanassche@gmail.com> wrote:

> On Wed, Apr 16, 2008 at 11:44 PM, Marc Perkel
> <mperkel@yahoo.com> wrote:
> >  --- Bart Van Assche <bart.vanassche@gmail.com>
> wrote:
> >  > It's better to correct the clock frequency once
> with
> >  > the tickadj or adjtimex, so you don't have to
> add
> >  > ntpdate to cron and you can still run ntpd.
> >  >
> >  > Bart.
> >
> >  ok - thanks. How do I do that?
> 
> You can do that as follows:
> * First of all, make sure that adjtimex is
> installed. Some distro's
> include this command in util-linux.
> * Query the current tick value via adjtimex -p |
> grep tick. E.g. with
> HZ = 100, tick == 10000.
> * Multiply the tick value with the relative clock
> error: when e.g. 3s
> are lost every hour, the correct tick value is 10000
> * (1 + 3/3600) =
> 10008.
> * Pass this new tick value to the kernel via
> adjtimex -t 10008.
> * Stop and restart ntpd such that it forgets any
> previous frequency estimates.
> * Keep an eye on the output of adjtimex -p|grep
> frequency to see
> whether the frequency estimate converges (should be
> stable within 10
> ppm after an hour. See also man adjtimex for the
> units of this value).
> 
> Bart.
> 

Thanks Bart - that seems to have worked. A value of
10025 seems to get it close enough for NTPD to lock
on. I'm using tickadj.

So - the question is - is this a kernel bug not
calibrating quad core phenoms right or do I just have
a bad motherboard?



Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com


      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
