Return-Path: <linux-kernel-owner+w=401wt.eu-S1751466AbXBVSLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466AbXBVSLE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 13:11:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbXBVSLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 13:11:04 -0500
Received: from terminus.zytor.com ([192.83.249.54]:43926 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbXBVSLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 13:11:01 -0500
Message-ID: <45DDDCAB.1000703@zytor.com>
Date: Thu, 22 Feb 2007 10:10:51 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Aristeu Sergio Rozanski Filho <aristeu.sergio@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tty_io: fix race in master pty close/slave pty close
 path
References: <20070222173744.GB6938@cathedrallabs.org>
In-Reply-To: <20070222173744.GB6938@cathedrallabs.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Aristeu Sergio Rozanski Filho wrote:
> 
> This normally would only issue a warning on idr_remove() but in case of a
> customer's critical application, it's never too simple:
> 
> thread1: opens master, gets index X
> thread1: begin closing master
> thread2: begin opening slave with index X
> thread1: finishes closing master, index X released
> thread3: opens master, gets index X, just released
> thread2: fails opening slave, releases index X         <----
> thread4: opens master, gets index X, init_dev() then find an already in use
> 	 and healthy tty and fails
> 

OK, that's fiendishly subtle, as most races are, of course.  I'll try to 
walk through the codepaths to make sure the proposed patch doesn't 
introduce a leak, but the concept sounds good.

	-hpa
