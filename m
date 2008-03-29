Return-Path: <linux-kernel-owner+w=401wt.eu-S1757565AbYC2Fuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbYC2Fuy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 01:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbYC2Fur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 01:50:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58364 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbYC2Fuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 01:50:46 -0400
Message-ID: <47EDD80C.6030507@zytor.com>
Date: Fri, 28 Mar 2008 22:47:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Laurent Riffard <laurent.riffard@free.fr>,
       Pavel Emelyanov <xemul@openvz.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] don't panic if /sbin/init exits or killed
References: <20080316155453.GA20845@tv-sign.ru>
In-Reply-To: <20080316155453.GA20845@tv-sign.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> If the buggy init exits, the kernel panics. I see no point for this. It is very
> possible that the system is still usable enough, at least to read the logs and
> prepare the bug report.
> 
> Change exit_child_reaper() to do BUG() instead of panic().
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

This would be highly undesirable in a production system, since it would 
leave the machine an unusable zombie.  In a production system, the panic 
can be made to reboot the system, bringing it back online.

	-hpa

