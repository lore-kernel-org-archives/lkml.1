Return-Path: <linux-kernel-owner+w=401wt.eu-S1030772AbXEQFA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030772AbXEQFA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 01:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760082AbXEQFAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 01:00:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52773 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933984AbXEQFAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 01:00:48 -0400
Date: Thu, 17 May 2007 06:00:46 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Convert namespace_sem to a mutex
Message-ID: <20070517050046.GM4095@ftp.linux.org.uk>
References: <20070517045041.GA4462@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070517045041.GA4462@in.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 10:20:41AM +0530, Bharata B Rao wrote:
> From: Bharata B Rao <bharata@linux.vnet.ibm.com>
> 
> namespace_sem is a rwsem. It is acquired as read sem at only one place(used
> by /proc/mounts, /proc/<pid>/mounts and /proc/<pid>/mountstats). In all other
> cases it is acquired as a write sem. So, as there is not more than one reader
> for this sem, this can be a generic sem (and not rwsem) and if so it can be
> a mutex.

Except that read accesses outnumber write ones by far and we have no reason
for serializing them against each other.  NAK.
