Return-Path: <linux-kernel-owner+w=401wt.eu-S1755541AbXHISOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbXHISOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 14:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752876AbXHISN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 14:13:59 -0400
Received: from mta-mad.optenet.com ([213.27.232.70]:39573 "EHLO
	mta-mad.optenet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbXHISN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 14:13:58 -0400
Subject: Re: [PATCH 1/1] af_packet: don't enable timestamps in mmap'ed
	sockets
From: Unai Uribarri <unai.uribarri@optenet.com>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070809143322.GA5345@2ka.mipt.ru>
References: <1186669314.24669.56.camel@localhost.localdomain>
	 <20070809143322.GA5345@2ka.mipt.ru>
Content-Type: text/plain
Organization: Optenet
Date: Thu, 09 Aug 2007 20:13:54 +0200
Message-Id: <1186683234.24669.65.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On jue, 2007-08-09 at 18:33 +0400, Evgeniy Polyakov wrote:
> On Thu, Aug 09, 2007 at 04:21:54PM +0200, Unai Uribarri (unai.uribarri@optenet.com) wrote:
> > The attached patch removes the automatic timestamp activation, that
> > only mmap'ed AF_PACKET sockets perform. I known it can break user
> > applications, but I believe that it's the correct solution.
> 
> How tcpdump with mmap libpcap will work with it?

In Linux, you can enable timestamps on any socket executing:

int val = 1;
setsockopt(sock, SOL_SOCKET, SO_TIMESTAMP, &val, sizeof(val));

PD: Current release of tcpdump doesn't mmap the reception ring and
timestamps packets at user space with gettimeofday. It isn't the best
performing alternative, but it's portable.



