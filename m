Return-Path: <linux-kernel-owner+w=401wt.eu-S1753638AbXLDL6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbXLDL6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 06:58:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbXLDL6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 06:58:30 -0500
Received: from sacred.ru ([62.205.161.221]:58673 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557AbXLDL6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 06:58:30 -0500
Message-ID: <475540D9.9010109@openvz.org>
Date: Tue, 04 Dec 2007 14:58:17 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       devel@openvz.org
Subject: Re: [PATCH 1/7][QUOTA] Move sysctl management code under ifdef CONFIG_SYSCTL
References: <475008F5.3000506@openvz.org>	<475009FA.20409@openvz.org>	<20071203133844.40804dab.akpm@linux-foundation.org>	<475516B6.5000504@openvz.org>	<20071204012301.4349bbd0.akpm@linux-foundation.org>	<47551E79.6080802@openvz.org>	<20071204014549.8fe47f7f.akpm@linux-foundation.org>	<m1zlwqy9g5.fsf@ebiederm.dsl.xmission.com> <20071204034836.47211436.akpm@linux-foundation.org>
In-Reply-To: <20071204034836.47211436.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 04 Dec 2007 14:58:17 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[snip]

>> We do have some current code in the network stack that fails miserably
>> when  register_sysctl_table returns NULL, and there are explicit
>> checks for that.
> 
> So that code would be failing today with CONFIG_SYSCTL=n?  Unless the
> failing code is itself under #ifdef CONFIG_SYSCTL, in which case we don't
> need to change anything?

Exactly! If the code checks for the return value it won't work
with CONFIG_SYSCTL=n, if it dies not - it may happily use the
sysctl stub and avoid extra ifdefs.

But this difference looks clumsy :(

Thanks,
Pavel
