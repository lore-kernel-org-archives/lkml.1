Return-Path: <linux-kernel-owner+w=401wt.eu-S1161531AbXEDVdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161531AbXEDVdy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 17:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161590AbXEDVdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 17:33:54 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55131 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161531AbXEDVdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 17:33:53 -0400
Date: Fri, 4 May 2007 14:33:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: Remove constructor from buffer_head
Message-Id: <20070504143347.9a1d6a34.akpm@linux-foundation.org>
In-Reply-To: <20070504134212.c18d2d65.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0705032007540.16627@schroedinger.engr.sgi.com>
	<20070504134212.c18d2d65.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2007 13:42:12 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> I'd investigate further, but someone has gone and broken oprofile.

Damn, we went and merged that bustage?


2.6.20:

akpm2:/home/akpm> opcontrol --start-daemon
/usr/bin/opcontrol: line 1098: /dev/oprofile/0/enabled: No such file or directory
/usr/bin/opcontrol: line 1098: /dev/oprofile/0/event: No such file or directory
/usr/bin/opcontrol: line 1098: /dev/oprofile/0/count: No such file or directory
/usr/bin/opcontrol: line 1098: /dev/oprofile/0/kernel: No such file or directory
/usr/bin/opcontrol: line 1098: /dev/oprofile/0/user: No such file or directory
/usr/bin/opcontrol: line 1098: /dev/oprofile/0/unit_mask: No such file or directory

2.6.21:

akpm2:/home/akpm# opreport -l /boot/vmlinux-$(uname -r) | head -50
opreport error: No sample file found: try running opcontrol --dump
or specify a session containing sample files



This is an FC6 machine.  `yum update oprofile' says

Could not find update match for oprofile
No Packages marked for Update/Obsoletion

akpm2:/home/akpm> rpm -q oprofile
oprofile-0.9.2-3.fc6


I'm quite stunned that we did this.

Now what?
