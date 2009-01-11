Return-Path: <linux-kernel-owner+w=401wt.eu-S1753147AbZAKVWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbZAKVWE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 16:22:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbZAKVVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 16:21:45 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:15094 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906AbZAKVVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 16:21:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XPHGpIWPmd9a5jn7Xb+DS4Hg8EmzItXqIn05qppjDDJVUHOAsnTHSLF6fSGw51mT6q
         xSLRqmCNqV9Fg1BWJEVqBipPrnVZG9lIuRud545MoTIXYQqeW3QpAROTSJtnOm9L+OcO
         DT5joT0m7SUOmkQ1gixjasxVCGqQ5JjELai04=
Date: Mon, 12 Jan 2009 00:27:00 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       devel@openvz.org, xemul@openvz.org
Subject: Re: [RFC 0/4] net namespace for PPP
Message-ID: <20090111212700.GA4008@x200.localdomain>
References: <4967acca.0437560a.511e.0221@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4967acca.0437560a.511e.0221@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2009 at 10:51:54PM +0300, Cyrill Gorcunov wrote:
> here is a series of RFC in attempt to implement
> net-namespaces for PPP protocol (including PPPoE
> and PPPoL2TP).

You need assign netns to netdevice after alloc_netdev().
This should fix much confusion and non-bugs mentioned in this thread.

After that struct ppp shouldn't need netns pointer as it will be netns
of it's netdevice.

current->nsproxy->net_ns while being correct in ioctl context
(it's synchronous) is easy to screwup. For example, in netfilter code netns
is taken from socket on which ioctl is done.

Regardless of netns, try_module_get() calls by hand are suspicious
and they're copied to netns init hook.
