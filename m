Return-Path: <linux-kernel-owner+w=401wt.eu-S1767350AbXECDrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767350AbXECDrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 23:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767351AbXECDrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 23:47:42 -0400
Received: from [212.12.190.26] ([212.12.190.26]:33000 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1767350AbXECDrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 23:47:41 -0400
From: Al Boldi <a1426z@gawab.com>
Subject: Re: Ext3 vs NTFS performance
Date: Thu, 3 May 2007 06:51:40 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Disposition: inline
To: linux-kernel@vger.kernel.org
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200705030651.40728.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
> On Tue, May 01, 2007 at 01:43:18PM -0700, Cabot, Mason B wrote:
> > I've been testing the NAS performance of ext3/Openfiler 2.2 against
> > NTFS/WinXP and have found that NTFS significantly outperforms ext3 for
> > video workloads. The Windows CIFS client will attempt a poor-man's
> > pre-allocation of the file on the server by sending 1-byte writes at
> > 128K-byte strides, breaking block allocation on ext3 and leading to
> > fragmentation and poor performance. This will happen for many
> > applications (including iTunes) as the CIFS client issues these
> > pre-allocates under the application layer.
> > 
> > I've posted a brief paper on Intel's OSS website
> > (http://softwarecommunity.intel.com/articles/eng/1259.htm). Please give
> > it a read and let me know what you think. In particular, I'd like to
> > arrive at the right place to fix this problem: is it in the filesystem,
> > VFS, or Samba?

It's a Samba problem.  Samba doesn't do async writes, which v3.0 should have 
fixed.  Did you try that?

> As I commented on IRC to Val Henson - the XFS performance indicates
> that it is not a VFS or Samba problem.

XFS somewhat hides the Samba problem, by efficiently syncing to disk.


Thanks!

--
Al

