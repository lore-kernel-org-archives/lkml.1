Return-Path: <linux-kernel-owner+w=401wt.eu-S933955AbXF2Qk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933955AbXF2Qk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 12:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763494AbXF2QkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 12:40:21 -0400
Received: from canuck.infradead.org ([209.217.80.40]:37213 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760139AbXF2QkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 12:40:20 -0400
Subject: Re: [PATCH] LinuxPPS (with new syscalls API) - new version
From: David Woodhouse <dwmw2@infradead.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070629163422.GP13886@enneenne.com>
References: <20070627224623.GO13886@enneenne.com>
	 <1183018133.1170.46.camel@pmac.infradead.org>
	 <20070628081538.GP13886@enneenne.com>
	 <1183019474.1170.66.camel@pmac.infradead.org>
	 <20070628084003.GQ13886@enneenne.com>
	 <1183031060.1170.145.camel@pmac.infradead.org>
	 <20070628161450.GD13886@enneenne.com>
	 <1183117082.1170.308.camel@pmac.infradead.org>
	 <20070629150813.GM13886@enneenne.com>
	 <1183132548.1170.360.camel@pmac.infradead.org>
	 <20070629163422.GP13886@enneenne.com>
Content-Type: text/plain
Date: Fri, 29 Jun 2007 17:40:52 +0100
Message-Id: <1183135253.17622.5.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-29 at 18:34 +0200, Rodolfo Giometti wrote:
> Gulp! Can you please give me some advices in order to solve also this
> problem? Should I use some "ifdef CONFIG_COMPAT" into those
> structures? :-o 

Remember you have to support _both_ 32-bit and 64-bit system calls. You
need to define struct compat_pps_info and struct compat_pps_params, and 
you'll have to provide a compat wrapper for sys_time_pps_getparams() and
sys_time_pps_setparams(). You'll also need to extend your
compat_sys_time_pps_fetch() wrapper to handle the struct pps_info too.

-- 
dwmw2

