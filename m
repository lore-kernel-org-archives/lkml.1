Return-Path: <linux-kernel-owner+w=401wt.eu-S933681AbXF2P4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933681AbXF2P4B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 11:56:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765693AbXF2Pzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 11:55:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48061 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758756AbXF2Pzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 11:55:50 -0400
Subject: Re: [PATCH] LinuxPPS (with new syscalls API) - new version
From: David Woodhouse <dwmw2@infradead.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070629150813.GM13886@enneenne.com>
References: <20070627174537.GM13886@enneenne.com>
	 <1182966588.1170.28.camel@pmac.infradead.org>
	 <20070627224623.GO13886@enneenne.com>
	 <1183018133.1170.46.camel@pmac.infradead.org>
	 <20070628081538.GP13886@enneenne.com>
	 <1183019474.1170.66.camel@pmac.infradead.org>
	 <20070628084003.GQ13886@enneenne.com>
	 <1183031060.1170.145.camel@pmac.infradead.org>
	 <20070628161450.GD13886@enneenne.com>
	 <1183117082.1170.308.camel@pmac.infradead.org>
	 <20070629150813.GM13886@enneenne.com>
Content-Type: text/plain
Date: Fri, 29 Jun 2007 16:55:47 +0100
Message-Id: <1183132548.1170.360.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-29 at 17:08 +0200, Rodolfo Giometti wrote:
> 
> +asmlinkage long sys_time_pps_fetch(int source, const int tsformat,
> +                                       struct pps_info __user *info, 
> +                                       const struct timespec __user *timeout)
> +{
> +       int ret;
> +       struct timespec to;
> +
> +       if (timeout) {
> +               ret = copy_from_user(&to, timeout, sizeof(struct timespec));
> +               if (ret)
> +                       return ret; 

You missed one. This should be -EFAULT too. And there's not a huge
amount of point in keeping the access_ok() checks elsewhere, since
copy_to_user() does that for itself.

Oh, and I think you do need compat magic for 'struct pps_info' and
'struct pps_params' too -- there's a struct timespec hidden deep in
there, as well as 'unsigned long longpad[3]'.

Can you explain the 'union pps_timeu'? It seems very odd. How do we know
which member of the union should be used?

-- 
dwmw2

