Return-Path: <linux-kernel-owner+w=401wt.eu-S1754311AbZEWJRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbZEWJRR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 05:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbZEWJRC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 05:17:02 -0400
Received: from comar.pardus.org.tr ([193.140.100.220]:49711 "EHLO
	pardus.org.tr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751324AbZEWJRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 05:17:01 -0400
Message-ID: <4A17BF10.4030604@pardus.org.tr>
Date: Sat, 23 May 2009 12:17:04 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Kunsheng Chen <linux_kernel_chan@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Why current->uid is not working in 2.6.29 ?
References: <784636.43001.qm@web111109.mail.gq1.yahoo.com>
In-Reply-To: <784636.43001.qm@web111109.mail.gq1.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kunsheng Chen wrote:
> Hello everyone,
>
> I am new to kernel module programming and got some problem while compiling some old kernel code. 
>
> The
> code is trying to get user id using current->uid,   but it is not
> working by reminding me 'task_struct; doesn't contain field uid '.  
>
> I checked the linux source code , uid is not there any more.
>   
They were replaced by some other calls. For example the following is a
snippet which ports the old code to the new API:

-                      address, current->uid);
+                      address, current_uid());


The commit 1330deb0f6e89525c8e9fcbd6b13522c9243bfc0 is a good example of
what are the new replacements.

This is all that I know,

Ozan Caglayan
