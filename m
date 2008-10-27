Return-Path: <linux-kernel-owner+w=401wt.eu-S1751639AbYJ0EIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639AbYJ0EIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 00:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbYJ0EIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 00:08:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60519 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbYJ0EIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 00:08:16 -0400
Date: Mon, 27 Oct 2008 04:08:15 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Cc: linux-kernel@vger.kernel.org, Linux-sh <linux-sh@vger.kernel.org>
Subject: Re: [PATCH] gdrom: Fix compile error
Message-ID: <20081027040814.GQ28946@ZenIV.linux.org.uk>
References: <29ab51dc0810261932n7580e87aua85103f8b1dcc5a5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29ab51dc0810261932n7580e87aua85103f8b1dcc5a5@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2008 at 11:32:27AM +0900, Nobuhiro Iwamatsu wrote:
> Return value and argument of block_device_operations.release of gdrom
> was changed.
> This patch fix this problem.

Serves me right for snide comments about the benefits of compile-testing ;-)
ACKed-by: Al Viro <viro@zeniv.linux.org.uk>

FWIW, sh/sh64 is the only cross-toolchain needed for the kernel I hadn't
managed to build - 4.3.0 gcc manages to trigger internal error in sh64 as(1)
(2.18.50.0.6) and AFAICS the same should happen with any binutils up to
-HEAD (the minimal testcase is
        .text
.LFB2:
        .section        .eh_frame,"a",@progbits
        .quad   .LFB2-.
and sh64 gcc4.3 routinely produces such things in its output).  gcc trunk
seems to have arseloads of changes in gcc/config/sh and I hadn't got around
to attempting a backport ;-/

Are there any public sh/sh64 toolchains based on not too heavily hacked
gcc/binutils, ideally for more or less recent variants of both?
