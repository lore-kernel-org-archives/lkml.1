Return-Path: <linux-kernel-owner+w=401wt.eu-S1764716AbXFEOKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764716AbXFEOKR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 10:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762166AbXFEOKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 10:10:05 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:1565 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761140AbXFEOKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 10:10:03 -0400
Date: Tue, 5 Jun 2007 18:18:49 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       linux-sparse@vger.kernel.org
Subject: sparse and ARRAY_SIZE() foolproofing
Message-ID: <20070605141849.GA16475@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For every valid ARRAY_SIZE() use sparse warns about
"cannot size expression". This is somewhat annoying, because code is OK.

$ cat 1.c
#define BUILD_BUG_ON_ZERO(e) (sizeof(char[1 - 2 * !!(e)]) - 1)
#define __must_be_array(a) BUILD_BUG_ON_ZERO(__builtin_types_compatible_p(typeof(a), typeof(&a[0])))
#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))

int f(void)
{
        int a[42];

        return ARRAY_SIZE(a);
}
$ sparse 1.c
1.c:9:9: error: cannot size expression

