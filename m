Return-Path: <linux-kernel-owner+w=401wt.eu-S935117AbZJONCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935117AbZJONCE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 09:02:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934796AbZJONCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 09:02:03 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55481 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933619AbZJONCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 09:02:02 -0400
Date: Thu, 15 Oct 2009 08:59:33 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Frans Pop <elendil@planet.nl>, Ferenc Wagner <wferi@niif.hu>,
       "ipw2100-devel@lists.sourceforge.net" 
	<ipw2100-devel@lists.sourceforge.net>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Ipw2100-devel] 2.6.32-rc4 ipw2200: oops on missing firmware
Message-ID: <20091015125933.GA2809@tuxdriver.com>
References: <87hbu3h023.fsf@tac.ki.iif.hu> <200910131855.25878.elendil@planet.nl> <1255589428.3719.465.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255589428.3719.465.camel@debian>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 15, 2009 at 02:50:28PM +0800, Zhu Yi wrote:

> OK. The rfkill device is removed without being added before! The root
> cause is, for non-monitor interfaces, the syntax for
> alloc_ieee80211/free_80211 is wrong. Because alloc_ieee80211 only
> creates (wiphy_new) a wiphy, but free_80211() does wiphy_unregister()
> also. This is only correct when the later wiphy_register() is called
> successfully, which apparently is not the case for your fw doesn't exist
> one. Please see if this patch fix the problem.
> 
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>

Thanks, Zhu!  That certainly looks better than what I had.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
