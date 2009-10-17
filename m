Return-Path: <linux-kernel-owner+w=401wt.eu-S1751598AbZJQCNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598AbZJQCNr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 22:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751053AbZJQCNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 22:13:46 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:44561 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbZJQCNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 22:13:45 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: Zhu Yi <yi.zhu@intel.com>
Cc: "ipw2100-devel@lists.sourceforge.net" 
	<ipw2100-devel@lists.sourceforge.net>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Ipw2100-devel] 2.6.32-rc4 ipw2200: oops on missing firmware
References: <87hbu3h023.fsf@tac.ki.iif.hu>
	<200910131855.25878.elendil@planet.nl>
	<1255589428.3719.465.camel@debian>
Date: Sat, 17 Oct 2009 04:13:43 +0200
In-Reply-To: <1255589428.3719.465.camel@debian> (Zhu Yi's message of "Thu, 15
	Oct 2009 14:50:28 +0800")
Message-ID: <87bpk64vjc.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhu Yi <yi.zhu@intel.com> writes:

> OK. The rfkill device is removed without being added before! The root
> cause is, for non-monitor interfaces, the syntax for
> alloc_ieee80211/free_80211 is wrong. Because alloc_ieee80211 only
> creates (wiphy_new) a wiphy, but free_80211() does wiphy_unregister()
> also. This is only correct when the later wiphy_register() is called
> successfully, which apparently is not the case for your fw doesn't exist
> one. Please see if this patch fix the problem.

I confirm that your patch fixes the problem for me.  With it, the
kernel doesn't oops and modprobe isn't killed after the firmware load
timeout.  Without firmware, the loaded module is nonfunctional, as
expected.
-- 
Thanks,
Feri.
