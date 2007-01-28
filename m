Return-Path: <linux-kernel-owner+w=401wt.eu-S932436AbXA1IAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436AbXA1IAG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 03:00:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932460AbXA1IAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 03:00:06 -0500
Received: from terminus.zytor.com ([192.83.249.54]:41921 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932436AbXA1IAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 03:00:04 -0500
Message-ID: <45BC57FB.4010209@zytor.com>
Date: Sat, 27 Jan 2007 23:59:55 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@openvz.org>
CC: akpm@osdl.org, devel@openvz.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] lutimesat: actual syscall and wire-up on i386
References: <20070126112345.GC11128@localhost.sw.ru>
In-Reply-To: <20070126112345.GC11128@localhost.sw.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> +asmlinkage long sys_lutimesat(int dfd, char __user *filename, struct timeval __user *utimes)

Could we get these to take struct timespec instead of struct timeval?

Right now we have a real problem in that the interfaces that *set* times 
take struct timeval (microsecond granularity) but the interfaces that 
*get* times return struct timespec (nanosecond granularity), which means 
information loss on any setting operations.

	-hpa

