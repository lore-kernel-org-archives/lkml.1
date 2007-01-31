Return-Path: <linux-kernel-owner+w=401wt.eu-S933308AbXAaOoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933308AbXAaOoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 09:44:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933309AbXAaOoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 09:44:25 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:33946 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933308AbXAaOoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 09:44:24 -0500
Date: Wed, 31 Jan 2007 14:44:23 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Eddie Pettis <pettis.eddie@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to locate struct file * from a bio?
Message-ID: <20070131144423.GB10050@ftp.linux.org.uk>
References: <d66e87630701310634s385db5adwa82e2194188efa81@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d66e87630701310634s385db5adwa82e2194188efa81@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 31, 2007 at 09:34:54AM -0500, Eddie Pettis wrote:
> Short question:  Is it possible to locate the struct file * associated
> with a bio?  If so, how?
 
Obviously impossible.  For one thing, there might very well be no inode,
let alone struct file, associated with bio in question (e.g. for any
filesystem metadata).  Moreover, the same on-disk object may get IO
without any stuct file at all (e.g. a directory) or with many struct
file (e.g. any file independently opened by several processes; no matter
how many of them do reads, we'll get stuff pulled into page cache the
same way (and once, not once per struct file).
