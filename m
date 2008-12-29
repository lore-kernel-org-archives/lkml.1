Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbYL2JFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbYL2JFD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 04:05:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbYL2JEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 04:04:45 -0500
Received: from fwil.voltaire.com ([193.47.165.2]:35246 "EHLO exil.voltaire.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752514AbYL2JEo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 04:04:44 -0500
X-Greylist: delayed 921 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Dec 2008 04:04:43 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 2.24.1.1 
Content-class: urn:content-classes:message
Subject: Re: linux-next: origin tree build failure
Date: Mon, 29 Dec 2008 10:48:19 +0200
Message-ID: <1230540499.4261.24.camel@alst60>
In-Reply-To: <20081229114321.4b6baea5.sfr@canb.auug.org.au>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: linux-next: origin tree build failure
Thread-Index: Aclpkk5w5XrthW/RQya3hkKlAjGvpw==
References: <20081229114321.4b6baea5.sfr@canb.auug.org.au>
From: "Aleksey Senin" <alekseys@voltaire.com>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
Cc: "Roland Dreier" <rdreier@cisco.com>, <general@lists.openfabrics.org>,
       <linux-next@vger.kernel.org>, "LKML" <linux-kernel@vger.kernel.org>,
       "Linus" <torvalds@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm going to change it by adding 

#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)

exactly as it solved in ipoib module and as Roland says.

On Mon, 2008-12-29 at 11:43 +1100, Stephen Rothwell wrote:
> Hi Roland,
> 
> Today's linux-next build (powerpc ppc64_defconfig) failed like this:
> 
> ERROR: ".ipv6_chk_addr" [drivers/infiniband/core/ib_addr.ko] undefined!
> ERROR: ".ip6_route_output" [drivers/infiniband/core/ib_addr.ko] undefined!
> 
> Caused by commit 38617c64bf9a10bf20e41d95b69bb81e8560fe9d ("RDMA/addr:
> Add support for translating IPv6 addresses").  This requires a dependency
> on IPV6.
> 
> I have reverted that commit for today (which fixes the build, but may not
> be the correct solution).
