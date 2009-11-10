Return-Path: <linux-kernel-owner+w=401wt.eu-S1757410AbZKJRYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbZKJRYL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 12:24:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757361AbZKJRYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 12:24:10 -0500
Received: from smtp.outflux.net ([198.145.64.163]:43039 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865AbZKJRYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 12:24:09 -0500
Date: Tue, 10 Nov 2009 09:23:35 -0800
From: Kees Cook <kees.cook@canonical.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org,
       Andrew Morgan <morgan@kernel.org>, Steve Grubb <sgrubb@redhat.com>,
       Andreas Gruenbacher <agruen@suse.de>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       George Wilson <gcwilson@us.ibm.com>
Subject: Re: drop SECURITY_FILE_CAPABILITIES?
Message-ID: <20091110172335.GI5129@outflux.net>
References: <20091110140739.GA15534@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091110140739.GA15534@us.ibm.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Nov 10, 2009 at 08:07:39AM -0600, Serge E. Hallyn wrote:
> Just a probe to see what people think.  I've seen two cases
> in about the last month where software was confounded by
> an assumption that prctl(PR_CAPBSET_DROP, CAP_SOMETHING)
> would succeed if privileged, but not handling the fact
> that SECURITY_FILE_CAPABILITIES=n means you can't do that.
> 
> Are we at the point yet where we feel we can get rid of
> the SECURITY_FILE_CAPABILITIES=n case?

It seems to me that the process caps bounding set (and file caps) are the
way forward and retaining the =n option is nonsense, especially since caps
are an integral part of the kernel.

> Does anyone know of cases where CONFIG_SECURITY_FILE_CAPABILITIES=n
> is still perceived as useful?

Building a kernel that willfully ignores fscaps?  I don't see the point.
It saves only a few bytes of code, AFAICT, and if it needs to be disabled
for some reason, the kernel boot option "no_file_caps" can be set.

At the very least it should default to "y" and/or have its help updated to
include the list of things it enables.

-Kees

-- 
Kees Cook
Ubuntu Security Team
