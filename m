Return-Path: <linux-kernel-owner+w=401wt.eu-S1752865AbZAKV4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbZAKV4U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 16:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZAKV4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 16:56:06 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:54814 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbZAKV4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 16:56:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kLGZuLEIonHAxnOpjMVXsHjqaWwUkm86Gr9/3nO7lJWjvjH9YAyxcRCdGJiIfZS62T
         kpOqGEg8TvvIkcuqc2QoihJn3sRi2fcuMpAX7WKuCtqWr3URfmSW2Df98IeOidCC1skr
         iU8KKpRpz39fvonb8FQH2ZilXVGAhYGLhohJo=
Date: Mon, 12 Jan 2009 00:56:03 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       devel@openvz.org, xemul@openvz.org
Subject: Re: [RFC 0/4] net namespace for PPP
Message-ID: <20090111215603.GB19261@localhost>
References: <4967acca.0437560a.511e.0221@mx.google.com> <20090111212700.GA4008@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090111212700.GA4008@x200.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Alexey Dobriyan - Mon, Jan 12, 2009 at 12:27:00AM +0300]
| On Fri, Jan 09, 2009 at 10:51:54PM +0300, Cyrill Gorcunov wrote:
| > here is a series of RFC in attempt to implement
| > net-namespaces for PPP protocol (including PPPoE
| > and PPPoL2TP).
| 
| You need assign netns to netdevice after alloc_netdev().
| This should fix much confusion and non-bugs mentioned in this thread.
| 
| After that struct ppp shouldn't need netns pointer as it will be netns
| of it's netdevice.

Good point, thanks!

| 
| current->nsproxy->net_ns while being correct in ioctl context
| (it's synchronous) is easy to screwup. For example, in netfilter code netns
| is taken from socket on which ioctl is done.

Didn't know that, will check.

| 
| Regardless of netns, try_module_get() calls by hand are suspicious
| and they're copied to netns init hook.
| 

Thanks a lot for comments Alexey! Module related calls are not needed
indeed.

		- Cyrill -
