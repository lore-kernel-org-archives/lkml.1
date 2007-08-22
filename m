Return-Path: <linux-kernel-owner+w=401wt.eu-S1764882AbXHVQo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764882AbXHVQo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 12:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762514AbXHVQov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 12:44:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58535 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762064AbXHVQou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 12:44:50 -0400
Message-ID: <46CC67F1.9020005@zytor.com>
Date: Wed, 22 Aug 2007 09:44:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andi Kleen <ak@suse.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org, Aaron Durbin <adurbin@google.com>
Subject: Re: [PATCH 0/3] x86_64 EFI runtime service support
References: <1187313920.28497.1.camel@caritas-dev.intel.com>	<46C5C8C4.4060407@zytor.com>	<1187580031.27947.67.camel@caritas-dev.intel.com>	<46C9CB89.7020603@zytor.com> <20070821113310.GF32640@bingen.suse.de>	<46CAC168.7090102@zytor.com> <20070821114548.GI32640@bingen.suse.de>	<86802c440708211658j1fb2a8caj41e1bb8bffa4baf4@mail.gmail.com>	<20070822012216.GN32640@bingen.suse.de>	<86802c440708212343x3b1438d3m4bbbfbd04db1f1ef@mail.gmail.com>	<20070822111155.GP32640@bingen.suse.de> <m1absjpr6w.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1absjpr6w.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> I need to review HPA changes a little more from his rewrite in C.
> I think he messed up with the guarantee of initialization in that
> rewrite, but I'm not quite certain.

I beg to differ, sir!

In my rewritten code, the "zeropage" is 4K of zero-initialized .bss,
into which the setup header is copied.

So any undefined field will be initialized to zero, not to whatever
assembly code happened to be there.

You know that with the old code, we got boot failures after changing the
error message in the dummy boot sector?

	-hpa
