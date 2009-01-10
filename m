Return-Path: <linux-kernel-owner+w=401wt.eu-S1755091AbZAJGN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091AbZAJGN5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 01:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbZAJGNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 01:13:49 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51463
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751005AbZAJGNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 01:13:48 -0500
Date: Fri, 09 Jan 2009 22:13:48 -0800 (PST)
Message-Id: <20090109.221348.166902734.davem@davemloft.net>
To: alexey.zaytsev@gmail.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rostedt@goodmis.org
Subject: Re: [PATCH] Disable branch profiling macros when sparsed.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090110052727.5471.3654.stgit@zaytsev.su>
References: <20090110052727.5471.3654.stgit@zaytsev.su>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Date: Sat, 10 Jan 2009 08:57:28 +0300

> The macros produce lots of unneeded warnings when
> recursive if(({ .. if() {..} ..})) {..} and such
> are substituted. And there is no point in sparsing
> them anyway. This is useful if someone decides to
> sparse an allyesconfig kernel.
> 
> Signed-off-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>

If even sparse can't handle these things, it's no surprise
how many gcc bogus warning problems we've run into because
of this hairy if() macro.

I don't think it's a good precedence to do this.  It's giving
up on trying to implement the branch tracer in a way that
results in a kernel build that produces useful warnings.
