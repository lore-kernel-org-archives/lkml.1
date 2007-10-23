Return-Path: <linux-kernel-owner+w=401wt.eu-S1753749AbXJWCDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbXJWCDp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 22:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbXJWCDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 22:03:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38303 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbXJWCDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 22:03:37 -0400
Date: Tue, 23 Oct 2007 03:03:36 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: linux-kernel@vger.kernel.org
Subject: [RFC] what the hell is going on with /proc/self?
Message-ID: <20071023020336.GC8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	What is the proc_base_stuff[] nonsense about?  AFAICS, that
went in with no reason whatsoever in
commit 801199ce805a2412bbcd9bfe213092ec656013dd
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Mon Oct 2 02:18:48 2006 -0700

	Rationale is very weak and patch adds considerable complexity
for no good reason.  Besides, it's obfuscated just for the hell of it:
	if (!IS_ERR(result) || PTR_ERR(result) != -ENOENT)
instead of
	if (result != ERR_PTR(-ENOENT))
etc.

	Unless there are _real_ plans that would justify that animal,
I'm going to get rid of it in the pending patch series (/proc/self
cleanups, saner dentry retention for non-process parts, etc.).
