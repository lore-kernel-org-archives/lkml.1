Return-Path: <linux-kernel-owner+w=401wt.eu-S932783AbXHJIex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932783AbXHJIex (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 04:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757536AbXHJIea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 04:34:30 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:33071 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763197AbXHJIe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 04:34:27 -0400
Date: Fri, 10 Aug 2007 12:34:18 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Unai Uribarri <unai.uribarri@optenet.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] af_packet: don't enable timestamps in mmap'ed sockets
Message-ID: <20070810083418.GA25479@2ka.mipt.ru>
References: <1186669314.24669.56.camel@localhost.localdomain> <20070809143322.GA5345@2ka.mipt.ru> <1186683234.24669.65.camel@localhost.localdomain> <20070809181823.GA32449@2ka.mipt.ru> <1186685061.24669.76.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186685061.24669.76.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Unai.

On Thu, Aug 09, 2007 at 08:44:21PM +0200, Unai Uribarri (unai.uribarri@optenet.com) wrote:
> There is another option:
> 
> 1. Move timestampt activation to packet_set_ring(), so it's activated
> only once at setup instead of every time a packet arrives.

Does this break existing systems which expects timestamp be turned on
always if there are packet sockets.

> 2. Fix sock_setsockopt() so setting SO_TIMESTAMP to 0 effectively
> disables timestamp.

This breaks compatibility. Add new socket option, which will really
disable it and do all your logic, but not breaking existing
applications.

-- 
	Evgeniy Polyakov
