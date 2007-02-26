Return-Path: <linux-kernel-owner+w=401wt.eu-S1161222AbXBZVnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161222AbXBZVnF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 16:43:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161224AbXBZVnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 16:43:05 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33462 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161222AbXBZVnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 16:43:04 -0500
Date: Mon, 26 Feb 2007 16:42:29 -0500
From: Dave Jones <davej@redhat.com>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: netconsole module cannot be removed
Message-ID: <20070226214229.GA9797@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Stephen Hemminger <shemminger@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <45E3447F.9080706@redhat.com> <20070226133156.3bfd2a74@freekitty>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070226133156.3bfd2a74@freekitty>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 26, 2007 at 01:31:56PM -0800, Stephen Hemminger wrote:
 > On Mon, 26 Feb 2007 15:35:11 -0500
 > Chuck Ebbert <cebbert@redhat.com> wrote:
 > 
 > > Trying to remove netconsole, rmmod goes into a tight loop with
 > > 100% CPU usage. It can't be killed with 'kill -9'. Shutdown
 > > works, though. Kernel is 2.6.20 FC6 config, and I'm 99.9%
 > > sure the module signing has nothing to do with this.
 > > 
 > 
 > No it probably has to do with printing a message during module removal.

I just reproduced this, and something really spooky happened.
After echo t > /proc/sysrq-trigger, the 'rmmod' process doesn't
show up in the backtrace. Everything else is there though.
The process shows up in a regular 'ps', but not in the sysrq output.

Most bizarre.

		Dave

-- 
http://www.codemonkey.org.uk
