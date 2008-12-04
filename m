Return-Path: <linux-kernel-owner+w=401wt.eu-S1757315AbYLDSUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbYLDSUe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 13:20:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755067AbYLDSUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 13:20:20 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:59778 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982AbYLDSUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 13:20:17 -0500
Date: Thu, 4 Dec 2008 12:20:05 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: sds@tycho.nsa.gov, jmorris@namei.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       takedakn@nttdata.co.jp, haradats@nttdata.co.jp
Subject: Re: [PATCH (mmotm-2008-12-02-17-08)] Introduce
	security_path_set/clear() hooks.
Message-ID: <20081204182005.GA14852@us.ibm.com>
References: <200812021939.FFC05200.OVQJSOMtFFHLFO@I-love.SAKURA.ne.jp> <1228225719.26101.52.camel@moss-spartans.epoch.ncsc.mil> <49364808.1070907@nttdata.co.jp> <493649C5.2060402@nttdata.co.jp> <1228313605.32059.23.camel@moss-spartans.epoch.ncsc.mil> <200812042100.HFE00081.tFFOHMQVOLFOSJ@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812042100.HFE00081.tFFOHMQVOLFOSJ@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tetsuo Handa (penguin-kernel@I-love.SAKURA.ne.jp):
> Hello.
> 
> Stephen Smalley wrote:
> > On Wed, 2008-12-03 at 17:56 +0900, Kentaro Takeda wrote:
> > > Stephen, Serge,
> > > Here is the patch for introducing new security_path_set()/clear() hooks.
> > > 
> > > This patch enables LSM module to remember vfsmount's pathname so that it can 
> > > calculate absolute pathname in security_inode_*(). Since actual MAC can be 
> > > performed after DAC, there will not be any noise in auditing and learning 
> > > features. This patch currently assumes that the vfsmount's pathname is stored in 
> > > hash table in LSM module. (Should I use stack memory?)
> > > 
> > > Since security_inode_*() are not always called after security_path_set(), 
> > > security_path_clear() hook is needed to free the remembered pathname.
> > 
> > Your security_path_set()/security_path_clear() pairs look rather similar
> > to mnt_want_write()/mnt_drop_write() pairs.  What if you were to call
> > your hooks from those functions, and then you would only need to add
> > further hook calls in the case of read-only and execute/search checks?
> 
> Right. Locations of inserting security_path_set()/security_path_clear() pairs
> are subset of mnt_want_write()/mnt_drop_write() pairs. Thus, we can insert
> security_path_set()/security_path_clear() pairs into
> mnt_want_write()/mnt_drop_write() pairs, if we can tolerate performance
> regression. According to our rough measurement, there is about 8 - 22% of
> performance regression.

... compared to what, exactly?

If having CONFIG_SECURITY_PATH=y but TOMOYO  disabled has this kind of
regression against just not having CONFIG_SECURITY_PATH, then no that is
not acceptable.

-serge
