Return-Path: <linux-kernel-owner+w=401wt.eu-S1031100AbXEEDNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031100AbXEEDNi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 23:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031104AbXEEDNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 23:13:38 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:16038 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031100AbXEEDNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 23:13:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=RRf2ysfAdcze7yUhBlsOCVzr9tWaEFeH3tENvgzwvo6SYAJLaHniDGzEWyDqhHS3SeuCSrmokscxqWOoUrvg3+K5wY+zd2FBXiyWliqq2Qd5lHn9e+lrVOQaom3o32by9IiEWzLt1BuRB/9P4ZVvAb3DYg5Ery/h/jwv03yXSlA=
Message-ID: <6ec7a4340705042013r4a78a705s43f07da97ec43569@mail.gmail.com>
Date: Sat, 5 May 2007 11:13:36 +0800
From: "Xu CanHao" <xucanhao@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Ext3 vs NTFS performance
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007 13:43:18 -0700
"Cabot, Mason B" <mason.b.ca...@intel.com> wrote:

> Hello all,

> I've been testing the NAS performance of ext3/Openfiler 2.2 against
> NTFS/WinXP and have found that NTFS significantly outperforms ext3 for
> video workloads. The Windows CIFS client will attempt a poor-man's
> pre-allocation of the file on the server by sending 1-byte writes at
> 128K-byte strides, breaking block allocation on ext3 and leading to
> fragmentation and poor performance. This will happen for many
> applications (including iTunes) as the CIFS client issues these
> pre-allocates under the application layer.

On 5 Mai, 10:20, Theodore Tso <t...@mit.edu> wrote:
>
> This is being worked on already.  XFS has a per-filesystem ioctl, but
> we want to create a filesystem-independent system call,
> sys_fallocate(), that would wired into the already existing
> posix_fallocate() function exported by glibc.

The story told us: an application must look to the file-systems, ext3
is good at aaa, is not good at bbb; XFS is good at ccc, is not good at
ddd; reiserfs is good at eee, is not good at fff........

For this scenario, XFS is good at dealing with fragmentation while ext3 not.
