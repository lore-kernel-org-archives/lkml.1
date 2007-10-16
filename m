Return-Path: <linux-kernel-owner+w=401wt.eu-S934140AbXJPQxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934140AbXJPQxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 12:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760789AbXJPQx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 12:53:27 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:50703 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760950AbXJPQxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 12:53:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HjVGSwhP1b04RdKfFPvWMyyf1jZoz+QjtYbBf/waBbQIpndrVOfF61CV3qKnHUTsJ3O49B0H1csJzMDybTicZOHfaYxJ2lI7mft39eHLM7hlP5kMjJ6I23GvzobNbeqSML1psROTVYMIKXu0I6PJWPKeXRZyNx/MkXw+1aOs2QI=
Message-ID: <d120d5000710160953w43e946f8ofd5bdbe152ea038e@mail.gmail.com>
Date: Tue, 16 Oct 2007 12:53:22 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Bryan Wu" <cooloney.lkml@gmail.com>
Subject: Re: [PATCH try #3] Input/Joystick Driver: add support AD7142 joystick driver
Cc: bryan.wu@analog.com, "Andrey Panin" <pazke@donpac.ru>,
       "Roel Kluin" <12o3l@tiscali.nl>,
       "Ahmed S. Darwish" <darwish.07@gmail.com>,
       linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, "Jean Delvare" <khali@linux-fr.org>
In-Reply-To: <386072610710152251k66529210x9311d2f2b202ad2b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192459625.6215.17.camel@roc-laptop>
	 <d120d5000710150848t1993b0aavbbc0cd7971e3ef3e@mail.gmail.com>
	 <386072610710151024s13e9c16qd7c974cde8000a9@mail.gmail.com>
	 <d120d5000710151040n2dbea5cbt515d3df87d5d19ed@mail.gmail.com>
	 <386072610710152251k66529210x9311d2f2b202ad2b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/07, Bryan Wu <cooloney.lkml@gmail.com> wrote:
> On 10/16/07, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > On 10/15/07, Bryan Wu <cooloney.lkml@gmail.com> wrote:
> > > On 10/15/07, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > > >
> > > > Completion is just not a good abstraction here... Please use work
> > > > abstraction and possibly a separate workqueue.
> > >
> > > Yes, I agree with you now, although I have a little concern about the
> > > possibility of big delay introduced by workqueue.
> > >
> >
> > Having a separate workqueue should isolate the driver from users
> > hogging keventd. Otherwise the speed should be pretty much the same as
> > with a kthread.
> >
>
> Does this driver need the create a new kthread instead of keventd?
> I think keventd might be sufficient for this driver.
>

No it does not have to start a new workqueue. I'd start with keventd
and only implement a separate workqueue later if I saw the driver
being starved by other keventd users.

-- 
Dmitry
