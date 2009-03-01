Return-Path: <linux-kernel-owner+w=401wt.eu-S1757206AbZCAOhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206AbZCAOhV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 09:37:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754705AbZCAOhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 09:37:04 -0500
Received: from rv-out-0506.google.com ([209.85.198.226]:16420 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980AbZCAOhB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 09:37:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=GyNK7W/fb2l2fWeurI5e2KIbK1bHN8mQio8jFWghbaTms8arRYcY0HBQsla/4M7Fxo
         mbYBauUsAI/QUUQVgoVejRj/KkO2va+nwBaXwa0SG4gNUIapSomt3ByhkyrUuaW+jTab
         CptHiOWK5kBbDLTOTJP/kDE9d9v9uLFQ6FXpU=
MIME-Version: 1.0
In-Reply-To: <1235884043.9224.12.camel@mj>
References: <1235688271-22346-1-git-send-email-jirislaby@gmail.com>
	 <20090226230338.M86894@bobcopeland.com> <49A7236E.2020807@gmail.com>
	 <b6c5339f0902261528i7b581125k29927c3c5ac4fe4c@mail.gmail.com>
	 <49A726A7.6090809@gmail.com> <20090227022704.GA29850@hash.localnet>
	 <1235884043.9224.12.camel@mj>
Date: Sun, 1 Mar 2009 09:36:59 -0500
X-Google-Sender-Auth: 048fd70e0772c055
Message-ID: <b6c5339f0903010636o15afa42en4e1b1eb81c2c06e2@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH 1/1] ath5k: fix hw rate index condition
From: Bob Copeland <me@bobcopeland.com>
To: Pavel Roskin <proski@gnu.org>
Cc: ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 1, 2009 at 12:07 AM, Pavel Roskin <proski@gnu.org> wrote:
> On Thu, 2009-02-26 at 21:27 -0500, Bob Copeland wrote:
>
>> Actually, I remembered in the dark recesses of my moldering brain
>> that someone had a lost patch for this a while ago, so I searched
>> the archives.  Pavel, ok to add your s-o-b?
>
> Since my patch was dropped and the new patch was implemented without my
> participation, it makes no sense to put my s-o-b on the code I didn't
> write (even though I wrote something similar before).

Ok, I just wanted to be sure to maintain proper credit, the "From" should
suffice.  I did rewrite the patch but it actually had an identical diff.
FWIW, the thread didn't give a clue why it didn't make it upstream, just
missed I guess (http://marc.info/?l=linux-wireless&m=122480002519627&w=2,
ultimately that problem was fixed by correctly setting the rs_more flag).

Anyway, the patch, while IMO correct, will still result in mac80211
warning in ieee80211_rx with -1 just as 255 will; it just fixes the
subsequent out of bound read.  If we want to tell mac80211 a real rate,
I think we should change it to s8 then hw_to_driver_rix should do
something like:

idx = array[x][y];
if (WARN_ON(idx < 0))
   idx = 0;

return idx;

Then we get the warning in the driver and we also return a real rate up
the stack.  I'll prep a patch for this unless there are any objections.

-- 
Bob Copeland %% www.bobcopeland.com
