Return-Path: <linux-kernel-owner+w=401wt.eu-S934123AbYD1NNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934123AbYD1NNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 09:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932454AbYD1NN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 09:13:29 -0400
Received: from relay2.sgi.com ([192.48.171.30]:34613 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932440AbYD1NN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 09:13:29 -0400
Date: Mon, 28 Apr 2008 08:13:26 -0500
From: Paul Jackson <pj@sgi.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: bert.wesarg@googlemail.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       travis@sgi.com
Subject: Re: [PATCH] Fix calculus of bitmap_scnprintf_len()
Message-Id: <20080428081326.fc62f1ce.pj@sgi.com>
In-Reply-To: <alpine.LFD.1.00.0804281414020.2870@localhost.localdomain>
References: <1209329003-22036-1-git-send-email-bert.wesarg@googlemail.com>
	<20080427160118.ad4cadf0.pj@sgi.com>
	<alpine.LFD.1.00.0804281414020.2870@localhost.localdomain>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bert wrote:
> The function bitmap_scnprintf_len() is currently not used

Paul Jackson wrote:
> How about we just remove that function?

WANG Cong wrote:
> I am afraid no. See:
> 
> include/linux/cpumask.h:292:    return bitmap_scnprintf_len(len);

Good point.


Then how about we also remove from cpumask.h:

#define cpumask_scnprintf_len(len) \
                        __cpumask_scnprintf_len((len))
static inline int __cpumask_scnprintf_len(int len)
{
        return bitmap_scnprintf_len(len);
}

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
