Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580AbZKQJzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbZKQJzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 04:55:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbZKQJzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 04:55:54 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:38026 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbZKQJzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 04:55:53 -0500
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: joe@perches.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl.c: Change a .proc_handler = proc_dointvec to
References: <20091115105957.GA1935@x200>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 17 Nov 2009 01:55:53 -0800
In-Reply-To: <20091115105957.GA1935@x200> (Alexey Dobriyan's message of "Sun\, 15 Nov 2009 13\:59\:57 +0300")
Message-ID: <m1ws1pfpau.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan@gmail.com> writes:

>> -		.proc_handler	= proc_dointvec
>> +		.proc_handler	= &proc_dointvec,
>
> NAK.
>
> commit 6d9f239a1edb31d6133230f478fd1dc2da338ec5
> Author: Alexey Dobriyan <adobriyan@gmail.com>
> Date:   Mon Nov 3 18:21:05 2008 -0800
>
>     net: '&' redux
>     
>     I want to compile out proc_* and sysctl_* handlers totally and
>     stub them to NULL depending on config options, however usage of &
>     will prevent this, since taking adress of NULL pointer will break
>     compilation.

I just experimented with this and found that at present a number of
the proc handlers wrap functions like proc_dointvec, so it does not work.

Did you have a plan for those?

Eric
