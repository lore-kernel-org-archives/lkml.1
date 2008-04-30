Return-Path: <linux-kernel-owner+w=401wt.eu-S1759310AbYD3AJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310AbYD3AJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 20:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755297AbYD3AJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 20:09:04 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:5877 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752614AbYD3AJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 20:09:03 -0400
Date: Wed, 30 Apr 2008 01:08:51 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] UTF-8 fixes in comments
Message-ID: <20080430000851.GH4818@implementation>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> 3) if I enter Alt-196, I get a "Ä". Flushing the buffer shows that od
> got two bytes: c3 84.

Confirmed.

Try init=/bin/stty -a, that will show

-iutf8

So there is little wonder that canonical mode does not work as expected.

Try init=/bin/sh, from that shell run stty iutf8. Then things will work
fine.  The fix is thus just to make the VT's tty initial iutf8 setup
follow vt.default_utf8.

Samuel
