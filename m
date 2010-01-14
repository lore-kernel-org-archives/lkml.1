Return-Path: <linux-kernel-owner+w=401wt.eu-S1755305Ab0ANBHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab0ANBHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 20:07:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043Ab0ANBHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 20:07:43 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:22427 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab0ANBHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 20:07:43 -0500
Date: Wed, 13 Jan 2010 20:07:09 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: task imap:2958 blocked for more than 120 seconds
Message-ID: <20100114010709.GD3428@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201001102105.47192.johannes.hirte@fem.tu-ilmenau.de>
 <20100110201926.GC32195@think>
 <201001132337.34909.johannes.hirte@fem.tu-ilmenau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001132337.34909.johannes.hirte@fem.tu-ilmenau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4B4E6E58.012C:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 11:37:33PM +0100, Johannes Hirte wrote:
> Am Sonntag 10 Januar 2010 21:19:26 schrieb Chris Mason:
> > On Sun, Jan 10, 2010 at 09:05:46PM +0100, Johannes Hirte wrote:
> > > I've observed this hanging task now several times. Not sure when this
> > > started, but 2.6.32 is affected too, IIRC. I don't have a test pattern
> > > for this. Dovecot imap triggers this from time to time. I've enabled
> > > CONFIG_DETECT_HUNG_TASK now
> > 
> > > and got this two tasks which hang:
> > You're stuck on a read, could you please do a sysrq-w when this happens?
> 
> Will do so when it happens again.

No need, I reread the trace, you're stuck in copy_from_user and probably
hitting a deadlock in the btrfs page faulting path.  This is pretty
rare, but I'll put it into the queue to fix up.
> 
> > Also, do you eventually recover or are you stuck forever?
> 
> I didn't wait too long when it happened, so I'm not sure.  The longest time 
> I've waited was 20-30min, until reboot without recover. So either it's stuck 
> forever or it takes really long to recover.
> 
> And one question I have: How do you identify a read in this call trace? 

Lock page followed by sync page is usually for reading.

-chris

