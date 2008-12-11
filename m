Return-Path: <linux-kernel-owner+w=401wt.eu-S1755718AbYLKEBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbYLKEBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 23:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754695AbYLKEBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 23:01:24 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:45549 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672AbYLKEBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 23:01:23 -0500
Date: Thu, 11 Dec 2008 04:01:18 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Nguyen Anh Quynh <aquynh@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       Kuniyasu Suzaki <k.suzaki@aist.go.jp>
Subject: Re: [PATCH] fix calls to request_module()
Message-ID: <20081211040118.GK28946@ZenIV.linux.org.uk>
References: <9cde8bff0812101935j5ef56140k67035d892a868738@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9cde8bff0812101935j5ef56140k67035d892a868738@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 12:35:21PM +0900, Nguyen Anh Quynh wrote:
> Hi,
> 
> The request_module() function should always have the 1st param as a
> format argument. So for example, request_module("i2c-powermac") should
> be called as request_module("%s", "i2c-powermac"). Otherwise, new gcc
> like gcc 4.3.2 on Ubuntu 8.10 would spit out a lot of warnings. This
> patch fixes them all in linus-git tree.

... and it doesn't address the underlying problems at all.  A string literal
without a single % in it is a perfectly sane and valid format.  _Why_ are
we getting these warning?
