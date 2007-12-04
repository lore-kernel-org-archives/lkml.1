Return-Path: <linux-kernel-owner+w=401wt.eu-S1753402AbXLDMuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbXLDMuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 07:50:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbXLDMuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 07:50:01 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:60198 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbXLDMuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:50:01 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH 1/7][QUOTA] Move sysctl management code under ifdef CONFIG_SYSCTL
References: <475008F5.3000506@openvz.org> <475009FA.20409@openvz.org>
	<20071203133844.40804dab.akpm@linux-foundation.org>
	<475516B6.5000504@openvz.org>
	<20071204012301.4349bbd0.akpm@linux-foundation.org>
	<47551E79.6080802@openvz.org>
	<20071204014549.8fe47f7f.akpm@linux-foundation.org>
	<m1zlwqy9g5.fsf@ebiederm.dsl.xmission.com>
	<20071204034836.47211436.akpm@linux-foundation.org>
	<475540D9.9010109@openvz.org>
Date: Tue, 04 Dec 2007 05:48:45 -0700
In-Reply-To: <475540D9.9010109@openvz.org> (Pavel Emelyanov's message of "Tue,
	04 Dec 2007 14:58:17 +0300")
Message-ID: <m1ve7ey6aa.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelyanov <xemul@openvz.org> writes:

> [snip]
>
>>> We do have some current code in the network stack that fails miserably
>>> when  register_sysctl_table returns NULL, and there are explicit
>>> checks for that.
>> 
>> So that code would be failing today with CONFIG_SYSCTL=n?  Unless the
>> failing code is itself under #ifdef CONFIG_SYSCTL, in which case we don't
>> need to change anything?
>
> Exactly! If the code checks for the return value it won't work
> with CONFIG_SYSCTL=n, if it dies not - it may happily use the
> sysctl stub and avoid extra ifdefs.
>
> But this difference looks clumsy :(

So we remove the check as we clean up the code.
Unless we happen to find something that can do something useful and
reasonable is register_sysctl_xxxx fails.

Eric
