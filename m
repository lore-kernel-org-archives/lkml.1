Return-Path: <linux-kernel-owner+w=401wt.eu-S1752346AbXLJWGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346AbXLJWGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 17:06:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbXLJWGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 17:06:17 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:8982 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbXLJWGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 17:06:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=qPR6v6cxBLhcj08EU+a9b4cTMvsFf5JZi7Z++WpZwLsaNYodKlJ3lQ/YkvqD9AaqaPOrhE5vbs3h8aJ/DokHT7zQ5+Oo5FxnIWQ7K06PT155TQw6RiIuu3a2m9dBFF13X5ZVfOT54cswykNIF16eboKUuWkBYXMy/yfAVfhjKa4=
Message-ID: <84144f020712101406i562ca243vd7b5fe6bfd1db05b@mail.gmail.com>
Date: Tue, 11 Dec 2007 00:06:15 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Jonathan Corbet" <corbet@lwn.net>
Subject: Re: [RFC] [PATCH] A clean approach to writeout throttling
Cc: "Daniel Phillips" <phillips@phunq.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Peter Zijlstra" <peterz@infradead.org>, linux-kernel@vger.kernel.org
In-Reply-To: <25797.1197322312@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200712051603.02183.phillips@phunq.net> <25797.1197322312@lwn.net>
X-Google-Sender-Auth: de09007a045c7e43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Dec 10, 2007 11:31 PM, Jonathan Corbet <corbet@lwn.net> wrote:
> I'm just getting around to looking at this.  One thing jumped out at me:
>
> > +     if (bio->bi_throttle) {
> > +             struct request_queue *q = bio->bi_queue;
> > +             bio->bi_throttle = 0; /* or detect multiple endio and err? */
> > +             atomic_add(bio->bi_throttle, &q->available);
> > +             wake_up(&q->throttle_wait);
> > +     }
>
> I'm feeling like I must be really dumb, but...how can that possibly
> work?  You're zeroing >bi_throttle before adding it back into
> q->available, so the latter will never increase...

Heh, well, that's ok as long as bio->bi_vcnt is set to zero and I think we
have some md raid drivers do just that... ;-)

                                Pekka
