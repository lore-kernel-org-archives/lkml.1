Return-Path: <linux-kernel-owner+w=401wt.eu-S1756075AbZCAFWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbZCAFWN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 00:22:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751104AbZCAFV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 00:21:57 -0500
Received: from c60.cesmail.net ([216.154.195.49]:31609 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbZCAFV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 00:21:56 -0500
Subject: Re: [ath5k-devel] [PATCH 1/1] ath5k: fix hw rate index condition
From: Pavel Roskin <proski@gnu.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Jiri Slaby <jirislaby@gmail.com>,
       "ath5k-devel@venema.h4ckr.net" <ath5k-devel@venema.h4ckr.net>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20090227030608.GA29974@hash.localnet>
References: <1235688271-22346-1-git-send-email-jirislaby@gmail.com>
	 <20090226230338.M86894@bobcopeland.com> <49A7236E.2020807@gmail.com>
	 <b6c5339f0902261528i7b581125k29927c3c5ac4fe4c@mail.gmail.com>
	 <49A726A7.6090809@gmail.com> <20090227022704.GA29850@hash.localnet>
	 <20090227023912.GF13456@tesla>  <20090227030608.GA29974@hash.localnet>
Content-Type: text/plain
Date: Sun, 01 Mar 2009 00:21:52 -0500
Message-Id: <1235884912.9224.26.camel@mj>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-26 at 22:06 -0500, Bob Copeland wrote:
> On Thu, Feb 26, 2009 at 06:39:12PM -0800, Luis R. Rodriguez wrote:
> > Might be worth adding a note why this is the case. Can't we simply avoid
> > this by checking earlier for the error or simply assigning it an actual
> > default _good_ hw rate value?
> 
> I guess an alternative is to initialize to 0, that would count any rx
> packets whose hw rate we don't know about as the base rate, so it would
> probably bias the RC to 1mb, but this is already one of those 'should 
> never happen' cases.

I would prefer that we don't hide problems.

If we don't know why we cannot get a valid rate, we should use WARN_ON
and find out why and when it happens.  I'm fine with using a bogus rate
with WARN_ON.

If we decide that we indeed cannot find the actual rate, then WARN_ON
should be removed and the bogus rate replaced with an "unknown rate",
that is, a special value that is never translated to a valid rate and
never given to any rate control algorithm.  Using a bogus rate without a
warning is wrong in my opinion.

It should be possible to represent "unknown rate" as such.  That applies
to all drivers.  I remember that b43 also failed to report the rate in
some cases (for the first received packet or something like that).

-- 
Regards,
Pavel Roskin
