Return-Path: <linux-kernel-owner+w=401wt.eu-S932482AbYETQQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482AbYETQQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 12:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbYETQQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 12:16:00 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:40907 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbYETQQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 12:16:00 -0400
Date: Tue, 20 May 2008 12:10:47 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Tom Spink <tspink@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: UML fails to locate address space
Message-ID: <20080520161047.GA9598@c2.user-mode-linux.org>
References: <7b9198260805200408k1d6b70a8xc7e4c24106e5020f@mail.gmail.com> <20080520135238.GB6990@c2.user-mode-linux.org> <7b9198260805200659p6ed28403t9b0b0ea995f158d5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b9198260805200659p6ed28403t9b0b0ea995f158d5@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 02:59:14PM +0100, Tom Spink wrote:
> Attached.  I guess the line of interest is:
> 
> mmap2(NULL, 4096, PROT_READ|PROT_WRITE,
> MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = -1 EACCES (Permission
> denied)

Yup.

Can you try three things:
	check the maps file for any arbitrary process
(i.e. /proc/$$/maps) and see if there's anything mapped at 0
	gdb UML, stop it at that mmap, check its maps file and see if
there's anything mapped at 0
	send me a pointer to the patches that Ubuntu has applied on
top of the stock kernel - I'm suspicious that they special-cased page
zero in order to ensure that NULL pointer dereferences cause faults.

You can test this last theory by initializing bottom to 4096 instead
of 0.

     	      	 	Jeff

-- 
Work email - jdike at linux dot intel dot com
