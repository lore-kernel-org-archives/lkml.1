Return-Path: <linux-kernel-owner+w=401wt.eu-S1759638AbZBMPqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759638AbZBMPqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 10:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbZBMPqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 10:46:09 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57682 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbZBMPqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 10:46:08 -0500
Subject: Re: [PATCH 1/1] ipw2200, fix ipw io functions
From: Dan Williams <dcbw@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       ipw2100-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Zhu Yi <yi.zhu@intel.com>, James Ketrenos <jketreno@linux.intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <1234474180-910-1-git-send-email-jirislaby@gmail.com>
References: <1234474180-910-1-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain
Date: Fri, 13 Feb 2009 10:44:14 -0500
Message-Id: <1234539854.3173.6.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-12 at 22:29 +0100, Jiri Slaby wrote:
> - some of them are defined as follows:
>   #define ipw_write32	expr1; expr2
>   and are called from loops or ifs without a compound statement, so
>   they are broken. Fix it by putting them into do {} while (0) for
>   writes and ({ }) for reads.
> - also unify and cleanup them while at it -- convert them from
>   macros to inline functions, so that we get some basic typechecking
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Zhu Yi <yi.zhu@intel.com>
> Cc: James Ketrenos <jketreno@linux.intel.com>
> Cc: Reinette Chatre <reinette.chatre@intel.com>

I've been running with this patch for 15 hours or so and it works well
for me.  It may have even fixed random issues with the card crapping out
after resume (successful association, does DHCP, but after a minute or
two no longer passes traffic until a hard reboot even with multiple
rmmod/modprobe runs), though that could also be hallucination on my
part.

Dan


