Return-Path: <linux-kernel-owner+w=401wt.eu-S1756023AbYGVEuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbYGVEuf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 00:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbYGVEuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 00:50:18 -0400
Received: from smtp115.mail.mud.yahoo.com ([209.191.84.164]:37446 "HELO
	smtp115.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750899AbYGVEuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 00:50:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Yaqd69c0rofkpI4BHCcn89JQ2EBSzmuyr/LzSmEwVnTDX3lNtv45f8YaMdbFXTzXYcdcJNmI//pDD4r9DtbQxSJBGVuhTZvA+dZ4vUF/J2XAk8BBz9Qm4g4OIGT8vw9oc0YGUOU8bBBGMm3h8FeIkG/oelBVn00Oj2wGtItY1Rc=  ;
X-YMail-OSG: pmCx710VM1lBeTI6O9Xw1Wgc0N.0fhA_qVVSKQCqoFkMJiFAsu98g6OmLbKcU8U0bUE_je2j2tdzEcdJbf9zINXyG2AQhI_SUCS9YVaAbpbtAUALsKVm.mAyY0rAQKWeRtw-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC] schedule_timeout_range()
Date: Tue, 22 Jul 2008 14:50:09 +1000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, arjan@infradead.org
References: <1216695757.18980.16.camel@shinybook.infradead.org> <200807221433.32412.nickpiggin@yahoo.com.au> <1216701925.18980.75.camel@shinybook.infradead.org>
In-Reply-To: <1216701925.18980.75.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807221450.10146.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 July 2008 14:45, David Woodhouse wrote:
> On Tue, 2008-07-22 at 14:33 +1000, Nick Piggin wrote:
> > The only thing I dislike about explicit times is that when a driver or
> > someone doesn't _really_ know how much to specify. Do you say 10s, 100s?
>
> This is true, but they certainly have a _better_ idea than we do. If the
> individual callers can't even come up with an answer, how are we ever
> going to come up with a generic policy that does the right thing?

OK, how about still having a never-until-machine-is-already-awake?


> I really don't think that applying this kind of policy in generic code
> is useful -- I'd like the callers to provide numbers even if they _do_
> pull it out of their wossname.
>
> The number they provide is the _maximum_ amount of time they should be
> prepared to wait (let's assume for a moment that they stayed sober and
> remembered Linux isn't a real-time kernel, so all guarantees are taken
> with a pinch of salt. Let's not get bogged down in nomenclature).

Well, I think it is still wise to avoid words like deadline, hard,
and timeout in the same sentence ;)


> In practice, they'll almost always get called before that maximum time
> expires -- that's the whole _point_, of course. But we can't _invent_
> that maximum in generic code; that's really up to the caller.

Not a maximum, but just an "I don't know... a lot?" define. But yeah
I guess there aren't too many good reasons for that.
