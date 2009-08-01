Return-Path: <linux-kernel-owner+w=401wt.eu-S1751849AbZHAPRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbZHAPRP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 11:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbZHAPRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 11:17:14 -0400
Received: from rtr.ca ([76.10.145.34]:38039 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653AbZHAPRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 11:17:13 -0400
Message-ID: <4A745C79.8030503@rtr.ca>
Date: Sat, 01 Aug 2009 11:17:13 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] fs/compat_ioctl.c: add missing FS_IOC_FIEMAP support
References: <4A74584D.2010300@rtr.ca>
In-Reply-To: <4A74584D.2010300@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
..
> Since FIBMAP itself is b0rked on ext4, this leaves no way for a 32-bit
..

To stave off the inevitable question, FIBMAP doesn't appear to cope well
with allocated/uncommitted blocks.  Creating a file with fallocate(),
and then immediately running FIBMAP, will not give any allocation data.

Doing a sync() after the fallocate() allows FIBMAP to work again.

FIEMAP doesn't require the sync().

Cheers
