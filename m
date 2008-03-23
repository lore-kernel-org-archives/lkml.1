Return-Path: <linux-kernel-owner+w=401wt.eu-S1761930AbYCWNQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761930AbYCWNQr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 09:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757182AbYCWNQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 09:16:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60932
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756020AbYCWNQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 09:16:35 -0400
Date: Sun, 23 Mar 2008 06:16:50 -0700 (PDT)
Message-Id: <20080323.061650.239772151.davem@davemloft.net>
To: vda.linux@googlemail.com
Cc: xemul@openvz.org, akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com,
       adobriyan@openvz.org
Subject: Re: [PATCH] Make /proc/net a symlink on /proc/self/net
From: David Miller <davem@davemloft.net>
In-Reply-To: <200803231400.41397.vda.linux@googlemail.com>
References: <47CE8FF7.7000701@openvz.org>
	<200803231400.41397.vda.linux@googlemail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Sun, 23 Mar 2008 14:00:41 +0100

> On Wednesday 05 March 2008 13:20, Pavel Emelyanov wrote:
> > Current /proc/net is done with so called "shadows", but current
> > implementation is broken and has little chances to get fixed.
> > 
> > The problem is that dentries subtree of /proc/net directory has
> > fancy revalidation rules to make processes living in different
> > net namespaces see different entries in /proc/net subtree, but
> > currently, tasks see in the /proc/net subdir the contents of any
> > other namespace, depending on who opened the file first.
> > 
> > The proposed fix is to turn /proc/net into a symlink, which points
> > to /proc/self/net, which in turn shows what previously was in
> > /proc/net - the network-related info, from the net namespace the
> > appropriate task lives in.
> > 
> > # ls -l /proc/net
> > lrwxrwxrwx  1 root root 8 Mar  5 15:17 /proc/net -> self/net
> 
> This broke tools which read /proc/net/dev. Under non-root,
> they are no longer working. This is a regression.

This is fixed with a commit that was made yesterday.
