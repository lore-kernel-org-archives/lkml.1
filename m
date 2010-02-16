Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933053Ab0BPSto (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 13:49:44 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:48885 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932368Ab0BPStm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 13:49:42 -0500
To: Octavian Purdila <opurdila@ixiacom.com>
Cc: David Miller <davem@davemloft.net>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Amerigo Wang <amwang@redhat.com>
Subject: Re: [net-next PATCH v4 0/3] net: reserve ports for applications using fixed port
References: <1266271241-6293-1-git-send-email-opurdila@ixiacom.com>
	<m1sk916qkv.fsf@fess.ebiederm.org>
	<201002162004.33533.opurdila@ixiacom.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 16 Feb 2010 10:49:37 -0800
In-Reply-To: <201002162004.33533.opurdila@ixiacom.com> (Octavian Purdila's message of "Tue\, 16 Feb 2010 20\:04\:33 +0200")
Message-ID: <m17hqd583i.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Octavian Purdila <opurdila@ixiacom.com> writes:

> Hi Eric, thanks for going over this.
>
> The use case (large bitmaps/lists) is different enough from what we have today 
> (small bitmaps) and that is why I think that we need this new interface. 
>
> If I get bitmap_parse_user correctly, for a 64k bitmap it expects a 2K comma 
> separated values. That is not the most intuitively way for the user to set a 
> list of ports he wants to reserve. 

In this case I expect an interface of comma separated ranges would be
ideal.  Typically compact, and modifiable by writing the new value to
the file.

I think the default value would be something like 32768-61000.

> Using 64K files has the same practical issues (the user would have to cat all 
> 64K files to determine which ports are reserved) plus it has issues caused by 
> the large number of files: significant memory overhead and also significant time 
> for registering those files.

"grep -l 1 *" isn't particularly difficult, and it would be one sysctl registration
call.  It is true that the sysctl memory footprint would be a pain in that case.

Eric




