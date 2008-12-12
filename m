Return-Path: <linux-kernel-owner+w=401wt.eu-S1757515AbYLLEb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515AbYLLEb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 23:31:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756017AbYLLEbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 23:31:18 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45195
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755894AbYLLEbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 23:31:18 -0500
Date: Thu, 11 Dec 2008 20:31:19 -0800 (PST)
Message-Id: <20081211.203119.180062878.davem@davemloft.net>
To: jeffrey.t.kirsher@intel.com
Cc: akpm@linux-foundation.org, frederik.deweerdt@xprog.eu,
       e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
       jesse.brandeburg@intel.com, linux-kernel@vger.kernel.org,
       stable@kernel.org, tglx@linutronix.de, zdenek.kabelac@gmail.com
Subject: Re: [PATCH] e1000e: fix double release of mutex
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081211215806.1173.24413.stgit@lost.foo-projects.org>
References: <20081211215806.1173.24413.stgit@lost.foo-projects.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Thu, 11 Dec 2008 13:58:07 -0800

> During a reset, releasing the swflag after it failed to be acquired would
> cause a double unlock of the mutex.  Instead, test whether acquisition of
> the swflag was successful and if not, do not release the swflag.  The reset
> must still be done to bring the device to a quiescent state.
> 
> This resolves [BUG 12200] BUG: bad unlock balance detected! e1000e
> http://bugzilla.kernel.org/show_bug.cgi?id=12200
> 
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

If we're fixing a regression like this, you should make the
patch against net-2.6, and this one is against net-next-2.6

Please respin this for me, thanks Jeff.
