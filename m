Return-Path: <linux-kernel-owner+w=401wt.eu-S1754091AbYKXQvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbYKXQvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 11:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbYKXQvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 11:51:15 -0500
Received: from smarthost02.mail.zen.net.uk ([212.23.3.141]:34013 "EHLO
	smarthost02.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753108AbYKXQvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 11:51:14 -0500
Subject: Re: [RFC PATCH] lro: ip fragment checking
From: Ben Hutchings <bhutchings@solarflare.com>
To: Jan-Bernd Themann <ossthema@de.ibm.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, tklein@de.ibm.com,
       Christoph Raisch <raisch@de.ibm.com>, jb.billaud@gmail.com,
       hering2@de.ibm.com
In-Reply-To: <492ACEC4.3020702@de.ibm.com>
References: <492ACEC4.3020702@de.ibm.com>
Content-Type: text/plain
Organization: Solarflare Communications
Date: Mon, 24 Nov 2008 16:51:08 +0000
Message-Id: <1227545468.3162.4.camel@achroite>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost02-IP: [82.69.137.158]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-24 at 16:56 +0100, Jan-Bernd Themann wrote:
> Currently there is no checking in the LRO receive path whether
> TCP packets are ip fragmented. We should not consider
> those packets for aggregation.
> I'm not sure if this checking is actually required. Does anyone
> know if it is possible to get fragmented TCP packets without
> the tcp stack changing the MSS size?
> This patch introduces explicit checking. Any objections?

LRO depends on the hardware performing TCP checksum offload, and the TCP
checksum cannot be verified for IP fragments in isolation.  So I think
drivers should not be passing fragments into inet_lro or should reject
them in its get_frag_header() or get_skb_header() method.  Certainly sfc
doesn't pass fragments into inet_lro because they have not been
checksummed.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

