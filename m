Return-Path: <linux-kernel-owner+w=401wt.eu-S1753324AbZB1Hxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbZB1Hxl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 02:53:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbZB1Hxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 02:53:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:59790 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540AbZB1Hxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 02:53:32 -0500
Message-ID: <49A8ED3D.1060704@kernel.org>
Date: Fri, 27 Feb 2009 23:52:29 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: brk patches..
References: <1235785882-17580-1-git-send-email-jeremy@goop.org> <1235785882-17580-4-git-send-email-jeremy@goop.org> <86802c440902272302n3787b2bex3741b46a372a19b0@mail.gmail.com> <49A8E235.6010900@goop.org> <20090228071534.GB9351@elte.hu> <49A8EA1A.50802@kernel.org>
In-Reply-To: <49A8EA1A.50802@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> wonder if boot loader check uncompress size aka vmlinux size in bzImage
> before it find one good position for bzImage...?
> 

Jeremy's brk patches may break:
1. kexec load 64bit vmlinux on some ram that near the memory hole etc.
blindly to use ram after _end may have some problem
2. coreboot aka linux is using elf (by mkelfImage : vmlinux + initrd), initrd became one section after _end...
could cause initrd get overwrite... by extend _brk

YH
