Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbYAGHKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbYAGHKu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 02:10:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbYAGHKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 02:10:43 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50779
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752940AbYAGHKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 02:10:43 -0500
Date: Sun, 06 Jan 2008 23:10:40 -0800 (PST)
Message-Id: <20080106.231040.222338659.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: bcrl@kvack.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: regression: sysctl_check changes in 2.6.24 are O(n) resulting
 in slow creation of 10000 network interfaces
From: David Miller <davem@davemloft.net>
In-Reply-To: <m1ir26ktqi.fsf@ebiederm.dsl.xmission.com>
References: <20080106220307.GU28570@kvack.org>
	<m1ir26ktqi.fsf@ebiederm.dsl.xmission.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 06 Jan 2008 23:57:57 -0700

> Why do we need 10000 interfaces?  Why isn't network device creation a
> slow path?

Because people create virtual devices like mad.

> So is this a bug report telling me that there are users with
> 10k or 100k interfaces that care.  So we need to fix sysctl.

Unquestionably, we do, it's a major regression.

People create thousands of VLAN devices, as one of many examples, all
the time.

That's why we even bother hashing network devices in the network code.
