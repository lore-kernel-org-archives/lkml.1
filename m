Return-Path: <linux-kernel-owner+w=401wt.eu-S1751517AbZL3AQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbZL3AQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 19:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbZL3AQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 19:16:15 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:57179 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbZL3AQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 19:16:15 -0500
Subject: Re: Question of resource_size() implementation
From: Felipe Balbi <me@felipebalbi.com>
Reply-To: me@felipebalbi.com
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1262131932.1888.202.camel@Joe-Laptop.home>
References: <1262130234.28789.112.camel@gandalf>
	 <1262131932.1888.202.camel@Joe-Laptop.home>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Dec 2009 02:16:11 +0200
Message-ID: <1262132171.28789.136.camel@gandalf>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-29 at 16:12 -0800, Joe Perches wrote:
> On Wed, 2009-12-30 at 01:43 +0200, Felipe Balbi wrote:
> > I'm wondering whether the +1 in resource_size() is actually necessary.
> > resource_size() is defined as:
> []
> > static inline resource_size_t resource_size(const struct resource *res)
> > {
> > 	return res->end - res->start + 1;
> > }
> > Are we off-by-one
> > here ? Or is this all expected ?
> 
> Imagine you have 1 byte sized resources.
> 
> AREA1 = 0x40000000
> AREA2 = 0x40000001
> 
> area1.start = 0x40000000
> area1.end   = 0x40000000
> 
> area2.start = 0x40000001
> area2.end   = 0x40000001

(adding lkml back to the loop)

in that you wouldn't use any of the SZ_* macros and simply hardcode
start and end, right ? then you would define:

area1.start = 0x40000000
area1.end = 0x40000001

and ioremap 2 bytes due to +1 in resource_size().

-- 
balbi

