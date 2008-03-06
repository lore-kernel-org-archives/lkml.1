Return-Path: <linux-kernel-owner+w=401wt.eu-S1761045AbYCFMZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761045AbYCFMZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 07:25:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753683AbYCFMYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 07:24:49 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34418 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939AbYCFMYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 07:24:48 -0500
Date: Thu, 6 Mar 2008 07:24:40 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Make /proc/net a symlink on /proc/self/net (v2)
Message-ID: <20080306122440.GA28561@infradead.org>
References: <47CFB6CA.8090001@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CFB6CA.8090001@openvz.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 12:18:02PM +0300, Pavel Emelyanov wrote:
> Current /proc/net is done with so called "shadows", but current
> implementation is broken and has little chances to get fixed.
> 
> The problem is that dentries subtree of /proc/net directory has
> fancy revalidation rules to make processes living in different
> net namespaces see different entries in /proc/net subtree, but
> currently, tasks see in the /proc/net subdir the contents of any
> other namespace, depending on who opened the file first.
> 
> The proposed fix is to turn /proc/net into a symlink, which points
> to /proc/self/net, which in turn shows what previously was in
> /proc/net - the network-related info, from the net namespace the
> appropriate task lives in.

Yes, that's a much better way to get this functionality.

