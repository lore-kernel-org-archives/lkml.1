Return-Path: <linux-kernel-owner+w=401wt.eu-S1761388AbYBLHVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761388AbYBLHVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 02:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759402AbYBLHVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 02:21:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42678
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758695AbYBLHVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 02:21:07 -0500
Date: Mon, 11 Feb 2008 23:21:39 -0800 (PST)
Message-Id: <20080211.232139.14959431.davem@davemloft.net>
To: chris.mason@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       btrfs-devel@oss.oracle.com
Subject: BTRFS partition usage...
From: David Miller <davem@davemloft.net>
In-Reply-To: <200802061200.14690.chris.mason@oracle.com>
References: <200802061200.14690.chris.mason@oracle.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Filesystems like ext2 put their superblock 1 block into the partition
in order to avoid overwriting disk labels and other uglies.  UFS does
this too, as do several others.  One of the few exceptions I've been
able to find is XFS.

This is a real issue on sparc where the default sun disk labels
created use an initial partition where block zero aliases the disk
label.  It took me a few iterations before I figured out why every
btrfs make would zero out my disk label :-/

