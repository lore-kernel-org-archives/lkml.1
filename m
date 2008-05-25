Return-Path: <linux-kernel-owner+w=401wt.eu-S1753995AbYEYGSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbYEYGSY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 02:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbYEYGSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 02:18:17 -0400
Received: from es1036.belits.com ([64.58.22.200]:59014 "EHLO es1036.belits.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbYEYGSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 02:18:16 -0400
X-Greylist: delayed 2084 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 May 2008 02:18:16 EDT
Date: Sat, 24 May 2008 22:44:37 -0700 (PDT)
From: Alex Belits <abelits@phobos.illtel.denver.co.us>
To: Bosko Radivojevic <bosko.radivojevic@gmail.com>
cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Inserting code from userspace to kernel space
In-Reply-To: <d6c8ef150805220541v711c5acahc60541e3fd9f44fc@mail.gmail.com>
Message-ID: <alpine.DEB.1.00.0805242244290.2200@OLPC>
References: <d6c8ef150805220541v711c5acahc60541e3fd9f44fc@mail.gmail.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008, Bosko Radivojevic wrote:

> I'm looking for a way to insert code from user space to the kernel
> space, but without using kernel module. Actually, we are working on a
> system that has to allow end user to change part of code (one or two
> functions) that is executed from the kernel space.
>
> For now we have two different kernel modules, one exporting a function
> which another module uses. Process of compiling kernel module is quite
> ineligible for standard end user (along with the requirement to
> support multi platform cross compiling) compared to just cross
> compiling a simple code that doesn't use any libraries than libc.

Why? You don't have to recompile everything, just link a module before 
loaing it -- a part containing the function can be one object file, the 
rest of the module (a wrapper) is compiled once for a particular kernel 
version, and both are linked together, producing a module valid for a 
particular kenel version.

This is how most of proprietary drivers are distributed, and Ubuntu has a 
whole infrastructure around that mechanism that simplifies transition 
between versions.

-- 
Alex
