Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849Ab0AGTcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab0AGTcK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 14:32:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839Ab0AGTcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 14:32:07 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:50413 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab0AGTcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 14:32:02 -0500
Date: Thu, 7 Jan 2010 11:30:46 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>, brgerst@gmail.com
Subject: Re: 2.6.33-rc2: Xen/Guest switching to user mode with no user page
 tables
In-Reply-To: <4B4633D3.2070903@zytor.com>
Message-ID: <alpine.DEB.2.01.1001071123220.3483@bogon.housecafe.de>
References: <alpine.DEB.2.01.1001051649100.3483@bogon.housecafe.de> <4B4405B5.9040205@goop.org> <alpine.DEB.2.01.1001060240010.3483@bogon.housecafe.de> <20100106112133.GA5815@lenovo> <alpine.DEB.2.01.1001060434330.3483@bogon.housecafe.de>
 <4B4633D3.2070903@zytor.com>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX18de/NBF/6152gmviYq130Io0QafJEc0Sz3fj2
 G1wQQ/n49bCL3d4ZigVcmEB3Rugzkt26umFXtD0fkahBz2s2Pf
 hmiJXNt7l+tNtSTI2dlEg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jan 2010 at 11:19, H. Peter Anvin wrote:
> The big difference between the code before and after this commit is that
> before, kernel_thread() would initialize the pt_regs structure with
> whatever state happened to be passed into it by the caller, whereas
> afterwards it is initialized to zero.

To be honest, bisection was kinda hazy in the last step (see my previous 
mails), but from looking at the bisection log, it's definitely one of 
your/Brians commit (sorry!), so it may be 3bd95dfb in combination with the 
other 4 changes. However, only with 3bd95dfb applied, the DomU wouldn't 
start at all. With the only other patches applied, the DomU would start, 
and then die with a GPF.

Christian.
-- 
BOFH excuse #191:

Just type 'mv * /dev/null'.
