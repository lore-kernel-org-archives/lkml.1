Return-Path: <linux-kernel-owner+w=401wt.eu-S1762111AbYCWNCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762111AbYCWNCZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 09:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755684AbYCWNCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 09:02:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:36356 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761944AbYCWNCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 09:02:09 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH] Make /proc/net a symlink on /proc/self/net
Date: Sun, 23 Mar 2008 14:00:41 +0100
User-Agent: KMail/1.8.2
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@openvz.org>
References: <47CE8FF7.7000701@openvz.org>
In-Reply-To: <47CE8FF7.7000701@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803231400.41397.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 March 2008 13:20, Pavel Emelyanov wrote:
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
> 
> # ls -l /proc/net
> lrwxrwxrwx  1 root root 8 Mar  5 15:17 /proc/net -> self/net

This broke tools which read /proc/net/dev. Under non-root,
they are no longer working. This is a regression.
--
vda
