Return-Path: <linux-kernel-owner+w=401wt.eu-S932663AbZAQV1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663AbZAQV1t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 16:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762409AbZAQV1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 16:27:39 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:38697 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762315AbZAQV1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 16:27:38 -0500
Subject: Re: btrfs: readdir problem workaround for 32-bit off_t
From: Chris Mason <chris.mason@oracle.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: linux-btrfs@vger.kernel.org, bug-glibc@gnu.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LSU.2.00.0901172026180.14987@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0901172026180.14987@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain
Date: Sat, 17 Jan 2009 16:27:21 -0500
Message-Id: <1232227641.28343.3.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010207.49724D3F.006D:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-17 at 20:39 +0100, Jan Engelhardt wrote:
> Hi,
> 
> 
> 
> I am seeing abnormal kernel<->userland interaction for range-exceeding 
> offsets during readdir.
> A suggested patch for btrfs is below, but I think there could also
> be involvement of (read: a bug in) Glibc.
> Would the copied parties please have a look, as it may spans both glibc 
> and btrfs.
> 

Thanks for looking into this.

Your patch is how the code originally looked, but it can lead to loops
in buggy userland (a git bug hit this).   My plan was to mask off the
limit the same way XFS now does.

This is a btrfs bug, not glibc.

-chris


