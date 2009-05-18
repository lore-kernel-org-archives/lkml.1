Return-Path: <linux-kernel-owner+w=401wt.eu-S1752843AbZERSgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbZERSgM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 14:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbZERSf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 14:35:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42322 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbZERSf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 14:35:56 -0400
Subject: Re: iwlagn broken in next-20090514 and next-20090515
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: reinette chatre <reinette.chatre@intel.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Nico -telmich- Schottelius <nico-linux-next@schottelius.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1242670211.29049.10.camel@johannes.local>
References: <20090515153733.4384db9f.sfr@canb.auug.org.au>
	 <20090515102621.GA5735@ikn.schottelius.org>
	 <20090518171505.d30d2f64.sfr@canb.auug.org.au>
	 <1242662635.32358.523.camel@rc-desk>
	 <1242663867.27425.1.camel@johannes.local>
	 <1242669029.3845.0.camel@localhost.localdomain>
	 <1242670211.29049.10.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 18 May 2009 14:35:20 -0400
Message-Id: <1242671720.3845.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-18 at 20:10 +0200, Johannes Berg wrote:
> On Mon, 2009-05-18 at 13:50 -0400, Dan Williams wrote:
> 
> > > > > > Also wpa_supplicant is not happy:
> > > > > > 
> > > > > > + wpa_supplicant -B -Dwext -iwlan0 -c /home/user/nico/ethz/wlan/wpa_supplicant.conf
> > > > > > ioctl[SIOCSIWENCODEEXT]: No such file or directory
> > > > > > ioctl[SIOCSIWENCODEEXT]: No such file or directory
> > > > > > ioctl[SIOCSIWENCODEEXT]: No such file or directory
> > > > > > ioctl[SIOCSIWENCODEEXT]: No such file or directory
> > > > > > 
> > > > 
> > > > There were some changes recently to this ioctl, but I am not familiar
> > > > with details. Johannes will know.
> > > 
> > > Yeah, I'm not sure -- this happens when clearing keys. I'll look into
> > > it, we probably need to accept removing a key that doesn't exist.
> > 
> > Why bother (if that's actually the root cause)?  Maybe the supplicant
> > should be fixed.  Other drivers return ENOENT in this case, so mac80211
> > certainly isn't out-of-common-spec here now.
> 
> I just looked at the code in wpa_supplicant, it doesn't care a bit, just
> prints the error. Problem is users attribute any other breakage to the
> error it prints since our behaviour changed...

I meant "make wpa_supplicant not print anything out on -ENOENT".

Dan


