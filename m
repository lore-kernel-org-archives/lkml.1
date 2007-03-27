Return-Path: <linux-kernel-owner+w=401wt.eu-S934284AbXC0W54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934284AbXC0W54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 18:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934288AbXC0W54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 18:57:56 -0400
Received: from tetsuo.zabbo.net ([207.173.201.20]:60101 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934284AbXC0W5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 18:57:55 -0400
In-Reply-To: <b040c32a0703271047vba81938q538d182c9c984f42@mail.gmail.com>
References: <b040c32a0703221751x54417524l5237742f345eeda9@mail.gmail.com> <20070322170122.ee2589a1.akpm@linux-foundation.org> <b040c32a0703231748s112beda6i3d51ebcd658005c4@mail.gmail.com> <20070326201552.b8ad7dda.akpm@linux-foundation.org> <b040c32a0703271047vba81938q538d182c9c984f42@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <3D4D126C-0B26-4B00-A2E4-68BD84555B51@oracle.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [patch] cache pipe buf page address for non-highmem arch
Date: Tue, 27 Mar 2007 15:57:53 -0700
To: Ken Chen <kenchen@google.com>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +#define pipe_kmap_atomic(page, type)	pipe_kmap(page)
> +#define pipe_kunmap(page)		do { } while (0)
> +#define pipe_kunmap_atomic(page, type)	do { } while (0)

Please don't drop arguments in stubs.  It can let completely broken  
code compile, like:

	pipe_kunmap(SOME_COMPLETE_NONSENSE);

Static inlines with empty bodies are the gold standard.

- z
