Return-Path: <linux-kernel-owner+w=401wt.eu-S1161255AbXDKGUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161255AbXDKGUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 02:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161250AbXDKGUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 02:20:13 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:43813 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1161257AbXDKGUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 02:20:11 -0400
Message-ID: <376272342.15519@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Wed, 11 Apr 2007 14:15:40 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Jin Steve <shjjiejin@hotmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Doc for your Adaptive ReadAhead patch
Message-ID: <20070411061540.GA5890@mail.ustc.edu.cn>
Mail-Followup-To: Jin Steve <shjjiejin@hotmail.com>,
	linux-kernel@vger.kernel.org
References: <20070411042707.GC11400@mail.ustc.edu.cn> <BAY128-F4C8C995FA1398AE0DF231B55F0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAY128-F4C8C995FA1398AE0DF231B55F0@phx.gbl>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2007 at 04:44:34AM +0000, Jin Steve wrote:
> Just like the function check_ra_success: (Does it mean: last time 
> RA>VM_MAX_CACHE_HIT, so next time no need readahead?)

The cache hit logic is to prevent doing pointless readahead for
an already cached file: the pages are already there.

VM_MAX_CACHE_HIT is the threshold to disable readahead in this case.

> static inline int check_ra_success(struct file_ra_state *ra,
> 			unsigned long nr_to_read, unsigned long actual)
> {
> 	if (actual == 0) {
> 		ra->cache_hit += nr_to_read;
> 		if (ra->cache_hit >= VM_MAX_CACHE_HIT) {
> 			ra_off(ra);
> 			ra->flags |= RA_FLAG_INCACHE;
> 			return 0;
> 		}
> 	} else {
> 		ra->cache_hit=0;
> 	}
> 	return 1;
> }
