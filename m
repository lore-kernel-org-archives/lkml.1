Return-Path: <linux-kernel-owner+w=401wt.eu-S1755127AbYACX6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbYACX6O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 18:58:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbYACX57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 18:57:59 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:38809 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbYACX56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 18:57:58 -0500
Date: Thu, 3 Jan 2008 23:57:36 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: advertise new restrictions on /proc/*/maps & /proc/*/smaps
Message-ID: <20080103235736.GW27894@ZenIV.linux.org.uk>
References: <20080103235150.2870.31703.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103235150.2870.31703.stgit@localhost.localdomain>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2008 at 12:51:50AM +0100, Guillaume Chazarain wrote:
> Now that strangers are kept out of /proc/<pid>/maps, let's welcome them
> with -EPERM instead of a blank file.

NAK

The whole point is that we have to reject it at read() time, not open()
time.  Checks in open() are
	a) useless (since conditions can change later)
and
	b) actually broken, since CAP_SYS_PTRACE != CAP_DAC_OVERRIDE
