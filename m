Return-Path: <linux-kernel-owner+w=401wt.eu-S1758380AbXIGRac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380AbXIGRac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 13:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757983AbXIGRaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 13:30:25 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:61799 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757973AbXIGRaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 13:30:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=axIw0O+4fK/JcLJK/ELRasTjzAlyeZzUXb41lifLJyRzk/xeuPnHM0fA8aEUS/uTNYvEh80QFUEa4KTQElCcHbLv1CoQjAC3j6A3uJYijl6BliY0svsqLjHRfyLLDGRd/BRVDSa0Tot5TVjlfBXQi4hRE9lMS3Slb5CdvGJGE5A=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH 0/3] build system: section garbage collection for vmlinux
Date: Fri, 7 Sep 2007 18:30:16 +0100
User-Agent: KMail/1.9.1
Cc: sam@ravnborg.org, linux-kernel@vger.kernel.org
References: <200709051443.21522.vda.linux@googlemail.com> <200709061807.33740.vda.linux@googlemail.com> <1189182671.6303.42.camel@imap.mvista.com>
In-Reply-To: <1189182671.6303.42.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709071830.17027.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 September 2007 17:31, Daniel Walker wrote:
> On Thu, 2007-09-06 at 18:07 +0100, Denys Vlasenko wrote:
> > A bit extended version:
> > 
> > In the process in making it work I saw ~10% vmlinux size reductions
> > (which basically matches what Marcelo says) when I wasn't retaining
> > sections needed for EXPORT_SYMBOLs, but module loading didn't work.
> > 
> > Thus I fixed that by adding KEEP() directives so that EXPORT_SYMBOLs
> > are never discarded. This was just one of many fixes until kernel
> > started to actually boot and work.
> > 
> > I did that before I posted patches to lkml.
> > IOW: posted patches are not broken versus module loading.
> 
> Ok, this is more like the explanation I was looking for..
> 
> During this thread you seemed to indicate the patches you release
> reduced the kernel ~10% , but now your saying that was pre-release ,
> right?

CONFIG_MODULE=n will save ~10%
CONFIG_MODULE=y - ~1%

Exact figure depends on .config (whether you happen to include
especially "fat" code or not).

I want to explain a bit where I am coming from. I am working on busybox,
and last release made busybox smaller by "whopping" 2%. This is the result
of a hundred or so of small code and data shrinks.

It basically means that I am close to the point of diminishing returns
trying to make busybox smaller, and memory wastage on the running
embedded system is now elsewhere - including kernel.
--
vda
