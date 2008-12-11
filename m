Return-Path: <linux-kernel-owner+w=401wt.eu-S1756148AbYLKEPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbYLKEPR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 23:15:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbYLKEPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 23:15:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751666AbYLKEPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 23:15:03 -0500
Date: Wed, 10 Dec 2008 20:14:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Nguyen Anh Quynh <aquynh@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Kuniyasu Suzaki <k.suzaki@aist.go.jp>
Subject: Re: [PATCH] fix calls to request_module()
Message-Id: <20081210201455.0c611484.akpm@linux-foundation.org>
In-Reply-To: <20081211040118.GK28946@ZenIV.linux.org.uk>
References: <9cde8bff0812101935j5ef56140k67035d892a868738@mail.gmail.com>
	<20081211040118.GK28946@ZenIV.linux.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2008 04:01:18 +0000 Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Thu, Dec 11, 2008 at 12:35:21PM +0900, Nguyen Anh Quynh wrote:
> > Hi,
> > 
> > The request_module() function should always have the 1st param as a
> > format argument. So for example, request_module("i2c-powermac") should
> > be called as request_module("%s", "i2c-powermac"). Otherwise, new gcc
> > like gcc 4.3.2 on Ubuntu 8.10 would spit out a lot of warnings. This
> > patch fixes them all in linus-git tree.
> 
> ... and it doesn't address the underlying problems at all.  A string literal
> without a single % in it is a perfectly sane and valid format.  _Why_ are
> we getting these warning?

extern int request_module(const char * name, ...) __attribute__ ((format (printf, 1, 2)));

?
