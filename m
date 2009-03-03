Return-Path: <linux-kernel-owner+w=401wt.eu-S1754345AbZCCNDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbZCCNDW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 08:03:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbZCCNDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 08:03:12 -0500
Received: from mail.deathmatch.net ([70.167.247.36]:2817 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbZCCNDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 08:03:11 -0500
Date: Tue, 3 Mar 2009 08:02:44 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Pavel Roskin <proski@gnu.org>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Jiri Slaby <jirislaby@gmail.com>,
       "ath5k-devel@venema.h4ckr.net" <ath5k-devel@venema.h4ckr.net>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ath5k-devel] [PATCH 1/1] ath5k: fix hw rate index condition
Message-ID: <20090303130244.GA4901@hash.localnet>
References: <20090226230338.M86894@bobcopeland.com> <49A7236E.2020807@gmail.com> <b6c5339f0902261528i7b581125k29927c3c5ac4fe4c@mail.gmail.com> <49A726A7.6090809@gmail.com> <20090227022704.GA29850@hash.localnet> <20090227023912.GF13456@tesla> <20090227030608.GA29974@hash.localnet> <1235884912.9224.26.camel@mj> <20090303034600.GA3757@hash.localnet> <40f31dec0903022031l20ecc3dcx9ba7859cb24fa5ae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40f31dec0903022031l20ecc3dcx9ba7859cb24fa5ae@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 03, 2009 at 06:31:05AM +0200, Nick Kossifidis wrote:
> 
> According to docs the rate field is only valid if more flag is clear
> (we have the last descriptor) and only if the receive ok flag is set
> or both receive ok and phy error flags are cleared. We never do such
> checks so we might actually try to process this field when we already
> know we shouldn't...

Well, we do skip rs_more packets without getting the rate, hopefully 
phy error packets too.  The warning would definitely show if we have 
any bugs there.

> Also the following rate codes are reserved (except XR codes that we
> already know):
[snip]
> and i don't believe i've ever seen them, so we can warn on them too
> and print something like "Reserved rate code: %x", also it would be
> nice to warn on XR rates (1,2,3,6,7) in case we want to debug this in
> the future.

Good idea, though I'm somewhat of the mind that we should let the 
current patch go in for a bit and see if any of these pop up.  But 
that's because I'm lazy :)  

-- 
Bob Copeland %% www.bobcopeland.com

