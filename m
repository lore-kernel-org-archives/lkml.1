Return-Path: <linux-kernel-owner+w=401wt.eu-S1756988AbYABE6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988AbYABE6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 23:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbYABE6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 23:58:12 -0500
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:36801 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbYABE6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 23:58:11 -0500
X-IronPort-AV: E=Sophos;i="4.24,232,1196661600"; 
   d="scan'208";a="512113222"
Date: Tue, 1 Jan 2008 22:58:00 -0600
From: Matt Domsch <Matt_Domsch@dell.com>
To: Theewara Vorakosit <thvo@hpcnc.cpe.ku.ac.th>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Get physical MAC address
Message-ID: <20080102045800.GC10762@auslistsprd01.us.dell.com>
References: <Pine.LNX.4.44.0712311233290.17732-100000@hpcnc.cpe.ku.ac.th>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0712311233290.17732-100000@hpcnc.cpe.ku.ac.th>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 31, 2007 at 12:39:11PM +0700, Theewara Vorakosit wrote:
> Hello,
> 
> I get MAC address from ioctl. However, ifconfig can change this  MAC 
> address. Can I get a real physical MAC address of the NIC?

yes.  It's ETHTOOL_GPERMADDR to the ethtool ioctl.

        case ETHTOOL_GPERMADDR:
                rc = ethtool_get_perm_addr(dev, useraddr);
                break;

When the driver is first loaded, before ifconfig can change the MAC
address, the existing (permanent) MAC address is stored away, able to
be retrieved via this ioctl.  Jon Wetzel, a Dell intern of a few
summers ago, wrote the code and was able to have it included.

Thanks,
Matt

-- 
Matt Domsch
Linux Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
