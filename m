Return-Path: <linux-kernel-owner+w=401wt.eu-S1758823AbYDDJhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823AbYDDJhl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 05:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbYDDJhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 05:37:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:63691 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbYDDJhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 05:37:31 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Slow tape drive timeout
To: Kai Makisara <Kai.Makisara@kolumbus.fi>, Robert Hancock <hancockr@shaw.ca>,
       Carlo Nyto <carlonyto@gmail.com>, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Fri, 04 Apr 2008 11:37:20 +0200
References: <aepft-NF-5@gated-at.bofh.it> <aepft-NF-7@gated-at.bofh.it> <aepfs-NF-3@gated-at.bofh.it> <aeCw6-5Yu-35@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1JhiML-0000lG-6H@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX193114u8hNDW9ZdZbxewvyxdSzx1PwG3J7Q4Sj
 kgiS80B7qpkGte2oioSKug1g430Cj7izXRULon4Pz7O7PsuoQG
 N/BI+c3ZnTWjIne3HURMg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kai Makisara <Kai.Makisara@kolumbus.fi> wrote:
> On Wed, 2 Apr 2008, Robert Hancock wrote:

>> Why is accessing the tape drive with no tape in it causing a timeout in the
>> first place? I should think that would fail immediately with some "medium not
>> present" error from the drive. Unless the drive has no mechanism to detect
>> it, but that seems really retarded..
>> 
> It does not seem retarded to me. If a program wants to just wait until the
> tape drive becomes ready (e.g., loads the tape), it can use the blocking
> open. This is simple.

This would be simple, if there were no timeout. Having the timeout, the program
must loop anyway.

> If a program wants to test the status, it uses 
> non-blocking open. The behavior mandated by the standards provides
> alternatives. If O_NONBLOCK is not supported, the user program must
> implement the waiting logic if the program just wants to wait until the
> drive is ready before starting i/o.

Therfore a portable program SHOULD implement a waiting logic that won't burn
the CPU if there is no tape in the drive.

It's still sane to allow waiting for media change, but this applies to any
removable media.

