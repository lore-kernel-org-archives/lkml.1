Return-Path: <linux-kernel-owner+w=401wt.eu-S1764209AbXGSV1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764209AbXGSV1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 17:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbXGSV1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 17:27:12 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:49640 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbXGSV1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 17:27:10 -0400
Date: Thu, 19 Jul 2007 16:24:53 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, tchicks@us.ibm.com,
       trevor.highland@gmail.com, pregan@ic.sunysb.edu, toml@us.ibm.com,
       sergeh@us.ibm.com, mhalcrow@us.ibm.com, mike@halcrow.us
Subject: [PATCH 0/8] eCryptfs: Support multiple keys per inode
Message-ID: <20070719212453.GA13821@halcrow.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches to eCryptfs introduces support for associating
multiple keys with individual files. When mounting, eCryptfs will
register one key for each key signature/identifier specified by an
ecryptfs_sig= mount option. These keys will all be used to encrypt the
FEK for each eCryptfs inode. This patch set also adds support for
searching the user's keyring for keys when opening existing files;
this allows the user to add keys to his keyring at any time, and
eCryptfs will use those keys to open files protected by those keys.
