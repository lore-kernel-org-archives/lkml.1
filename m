Return-Path: <linux-kernel-owner+w=401wt.eu-S1752800AbYLCOQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbYLCOQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 09:16:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750843AbYLCOQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 09:16:08 -0500
Received: from zombie2.ncsc.mil ([144.51.88.133]:51794 "EHLO zombie2.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbYLCOQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 09:16:06 -0500
Subject: Re: [PATCH (mmotm-2008-12-02-17-08)] Introduce
	security_path_set/clear() hooks.
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: serue@us.ibm.com, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, haradats@nttdata.co.jp,
       James Morris <jmorris@namei.org>
In-Reply-To: <493649C5.2060402@nttdata.co.jp>
References: <20081120112543.799450455@I-love.SAKURA.ne.jp>
	 <20081120112727.557697893@I-love.SAKURA.ne.jp>
	 <1228161612.18720.211.camel@moss-spartans.epoch.ncsc.mil>
	 <200812021939.FFC05200.OVQJSOMtFFHLFO@I-love.SAKURA.ne.jp>
	 <1228225719.26101.52.camel@moss-spartans.epoch.ncsc.mil>
	 <49364808.1070907@nttdata.co.jp>  <493649C5.2060402@nttdata.co.jp>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 03 Dec 2008 09:13:25 -0500
Message-Id: <1228313605.32059.23.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-03 at 17:56 +0900, Kentaro Takeda wrote:
> Stephen, Serge,
> Here is the patch for introducing new security_path_set()/clear() hooks.
> 
> This patch enables LSM module to remember vfsmount's pathname so that it can 
> calculate absolute pathname in security_inode_*(). Since actual MAC can be 
> performed after DAC, there will not be any noise in auditing and learning 
> features. This patch currently assumes that the vfsmount's pathname is stored in 
> hash table in LSM module. (Should I use stack memory?)
> 
> Since security_inode_*() are not always called after security_path_set(), 
> security_path_clear() hook is needed to free the remembered pathname.

Your security_path_set()/security_path_clear() pairs look rather similar
to mnt_want_write()/mnt_drop_write() pairs.  What if you were to call
your hooks from those functions, and then you would only need to add
further hook calls in the case of read-only and execute/search checks?

-- 
Stephen Smalley
National Security Agency

