Return-Path: <linux-kernel-owner+w=401wt.eu-S1752846AbXL0H1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbXL0H1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 02:27:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750890AbXL0H1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 02:27:42 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52093 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbXL0H1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 02:27:41 -0500
Message-ID: <477353B6.6000102@cn.fujitsu.com>
Date: Thu, 27 Dec 2007 15:26:46 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: fib6_del_route has redundant code
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
I think the following code in fib6_del_route in the latest kernel is useless.
1125         if (fn->leaf == NULL && fn->fn_flags&RTN_TL_ROOT)
1126                 fn->leaf = &ip6_null_entry;

ip6_null_entry will never be unlinked from fn->leaf now, that is, fn->leaf == NULL will never meet.

In previous kernel, When adding a default route, ip6_null_entry will be unlinked from fn->leaf.
So, when deleting a default route, it need to check whether the deleted route is the last one,
if so, ip6_null_entry will link to fn->leaf again.

I am not sure if there is another place unlinks ip6_null_entry from fn->leaf.

Regards,
Gui Jiafeng
