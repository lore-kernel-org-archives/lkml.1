Return-Path: <linux-kernel-owner+w=401wt.eu-S932823AbXBQT35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932823AbXBQT35 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 14:29:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932824AbXBQT35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 14:29:57 -0500
Received: from terminus.zytor.com ([192.83.249.54]:38609 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932823AbXBQT34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 14:29:56 -0500
Message-ID: <45D757AD.30208@zytor.com>
Date: Sat, 17 Feb 2007 11:29:49 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Mockern@yandex.ru
CC: linux-kernel@vger.kernel.org
Subject: Re: serial or tty driver
References: <45D7255D.000003.24001@webmail18.yandex.ru>
In-Reply-To: <45D7255D.000003.24001@webmail18.yandex.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mockern wrote:
> I have a question, what is really difference between serial and tty drivers?
> As I understand tty is high level and communicates with user space. 

That's pretty much it, yes.  When you're talking to a serial port, you 
have a stack that looks roughly like:

	(Userspace)
	VFS layer
	tty layer ----------------------\
	serial core layer                line discipline
	serial driver
	(Hardware)

There are other devices which can exist below the tty layer, like the 
pty driver:

	(Userspace)
	VFS layer
	tty layer ----------------------\
	pty driver                       line discipline

	-hpa
