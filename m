Return-Path: <linux-kernel-owner+w=401wt.eu-S1758009AbZEaJLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009AbZEaJLr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 05:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbZEaJLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 05:11:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42754 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991AbZEaJLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 05:11:36 -0400
Message-ID: <4A2249C5.5000809@redhat.com>
Date: Sun, 31 May 2009 12:11:33 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: Mark McLoughlin <markmc@redhat.com>,
       Gregory Haskins <gregory.haskins@gmail.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>,
       mtosatti@redhat.com
Subject: Re: [KVM PATCH v4 3/3] kvm: add iosignalfd support
References: <20090526191010.20860.75372.stgit@dev.haskins.net>	 <20090526191539.20860.1385.stgit@dev.haskins.net>	 <4A1D01F8.8080508@redhat.com> <4A1D285C.9050008@novell.com>	 <4A1D2DD8.2050709@redhat.com> <1243445144.16318.15.camel@blaa>	 <4A1D7AFD.40004@novell.com> <1243446484.4852.13.camel@blaa>	 <4A1DA653.4050109@gmail.com> <1243501772.4046.36.camel@blaa> <4A1E7FA0.8060300@novell.com>
In-Reply-To: <4A1E7FA0.8060300@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> This is closer to how the original series worked, but Avi asked for a
> data-match token and thus the cookie was born.  I think the rationale is
> that we can't predict whether the same eventfd will be registered more
> than once, and thus we need a way to further qualify it.  However, to
> your point, I cannot think of a valid use case for having the same fd
> registered to the same address more than once, so perhaps your fd/addr
> tuple is sufficient and we can drop the cookie (or, really, rename it to
> "trigger" ;)
>
> Avi?
>   

This is just how virtio works.  To kick ring N of device X, it writes N 
to a port specific to X.

If we lose N, then we don't know which ring was kicked and have to check 
them all.

May we can rename cookie to data_match to make it explicit.  If the data 
doesn't match, the eventfd isn't kicked.

(Mark, same as we have arbitrary ring->MSI mappings (allowing one MSI to 
notify multiple rings), perhaps we should have the same capability for 
the other direction?  So the guest could kick mulitple rings with one 
write, or just one ring, according to personal preference.

-- 
error compiling committee.c: too many arguments to function

