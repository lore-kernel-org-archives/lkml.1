Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752640AbYLRUGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbYLRUGw (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 15:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbYLRUG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 15:06:26 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:59162 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbYLRUGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 15:06:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=SgtS0NPKxSoDFaA54vC2i4MT2OedIYxclHTwAKd6ZQoOgd3jxgifqaPs8YtpNez6/G
         YDoC8EjIpPRNzOzdm1PsU2qKe4WL0hoA4MRGYWPo49ypb4RA/mp8Y+V96JJ/RJmeA3Po
         pgNDAoeU/Rp8O0z9dkef1GPb8ZbCzwqmcpYms=
Message-ID: <84144f020812181206o3d85fbd3t6b30346d7cf76d9d@mail.gmail.com>
Date: Thu, 18 Dec 2008 22:06:21 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Christoph Lameter" <cl@linux-foundation.org>
Subject: Re: [PATCH 03/15] kmemleak: Add the slab memory allocation/freeing hooks
Cc: "Catalin Marinas" <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0812181334590.17255@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
	 <20081210182710.30323.57396.stgit@pc1117.cambridge.arm.com>
	 <494184AA.8090509@cs.helsinki.fi>
	 <1229092065.15045.35.camel@pc1117.cambridge.arm.com>
	 <1229597162.1047.48.camel@penberg-laptop>
	 <1229618308.16418.50.camel@pc1117.cambridge.arm.com>
	 <Pine.LNX.4.64.0812181048160.12300@quilx.com>
	 <1229619764.16418.54.camel@pc1117.cambridge.arm.com>
	 <Pine.LNX.4.64.0812181334590.17255@quilx.com>
X-Google-Sender-Auth: 67fa6da3dc351c0e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2008 at 9:35 PM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> On Thu, 18 Dec 2008, Catalin Marinas wrote:
>
>> OK, but is there a chance that an stale pointer remains in such caches?
>
> Definitely. The pointers are never cleared. There are counters in the
> caches that are used to index into an array.
>
>> There seems to be the transfer_objects() function that moves pointers
>> around but doesn't clear the source values.
>
> No need to. The counter updates take care of things.

For kmemleak, that's a problem. Unless we explicitly annotate the
caches, it will scan them and think that there's a pointer to a leaked
object (i.e. false negative). Catalin already took care of the per-CPU
caches but AFAICT we still need to take care of the per-node caches
and the shared caches.
