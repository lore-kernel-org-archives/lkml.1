Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933269Ab0BPTyi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 14:54:38 -0500
Received: from ixro-out-rtc.ixiacom.com ([92.87.192.98]:19607 "EHLO
	ixro-ex1.ixiacom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755554Ab0BPTyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 14:54:37 -0500
From: Octavian Purdila <opurdila@ixiacom.com>
Organization: Ixia
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [net-next PATCH v4 0/3] net: reserve ports for applications using fixed port
Date: Tue, 16 Feb 2010 21:51:04 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.32-2-686; KDE/4.3.2; i686; ; )
Cc: David Miller <davem@davemloft.net>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Amerigo Wang <amwang@redhat.com>
References: <1266271241-6293-1-git-send-email-opurdila@ixiacom.com> <201002162004.33533.opurdila@ixiacom.com> <m17hqd583i.fsf@fess.ebiederm.org>
In-Reply-To: <m17hqd583i.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002162151.04861.opurdila@ixiacom.com>
X-OriginalArrivalTime: 16 Feb 2010 19:54:35.0523 (UTC) FILETIME=[DD5F5D30:01CAAF41]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 February 2010 20:49:37 you wrote:

> > The use case (large bitmaps/lists) is different enough from what we have
> > today  (small bitmaps) and that is why I think that we need this new
> > interface.
> >
> > If I get bitmap_parse_user correctly, for a 64k bitmap it expects a 2K
> > comma  separated values. That is not the most intuitively way for the
> > user to set a list of ports he wants to reserve.
> 
> In this case I expect an interface of comma separated ranges would be
> ideal.  Typically compact, and modifiable by writing the new value to
> the file.
> 

Something like bellow?

# set bits 8080 and 1666 
$echo 8080 1666-1666 > /proc

#reset bit 1666
$echo 8080 > /proc

#reset whole bitmap
$echo > /proc

> I think the default value would be something like 32768-61000.

Note that this new proc entry will work in conjunction with the existing 
ip_local_port_range option, so the default bitmap can (and should be) empty.
