Return-Path: <linux-kernel-owner+w=401wt.eu-S1756647AbZKSOxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbZKSOxL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 09:53:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbZKSOxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 09:53:10 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:58850 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbZKSOxK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 09:53:10 -0500
Subject: Re: NET: Questions about supporting older kernel's with kmods
From: Ben Hutchings <bhutchings@solarflare.com>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4B055479.8070101@gmail.com>
References: <4B055479.8070101@gmail.com>
Content-Type: text/plain; charset=UTF-8
Organization: Solarflare Communications
Date: Thu, 19 Nov 2009 14:53:13 +0000
Message-Id: <1258642393.2837.5.camel@achroite.uk.solarflarecom.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 19 Nov 2009 14:53:27.0293 (UTC) FILETIME=[0D1A82D0:01CA6928]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.000.1038-17018.004
X-TM-AS-Result: No--17.434200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-19 at 09:21 -0500, Gregory Haskins wrote:
> Hi All,
> 
> So I was in the process of packaging up my venet driver so that it could
> not only support the in-tree build (in -next), but also build as a KMP
> for inclusion in existing distros that already shipped (like SLE, RHEL,
> CentOS, etc).
> 
> The problem I ran into is that the ethtool and netdev_ops components of
> the in-tree version do not necessarily align with the substrate
> capabilities of older kernels.  What are the best-practices surrounding
> this issue?
>
> Q1) Is there any official CONFIG tags (e.g. HAVE_NETDEV_OPS) I can key
> off of,

These feature test macros are not consistently provided.

> or should I simply look at the kernel version?

That works up to a point, but the 'enterprise' distros backport a lot to
earlier kernel versions which can make version tests invalid.

Some out-of-tree/backported drivers use autoconf-style tests, but there
is no standard way of doing this.

﻿[...]
> Q2) Is it considered "bad form" to include such compile-time directives
> in the version of the code going upstream?
[...]

Yes.  Don't do that.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

