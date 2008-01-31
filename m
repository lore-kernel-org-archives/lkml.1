Return-Path: <linux-kernel-owner+w=401wt.eu-S1764235AbYAaIME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764235AbYAaIME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 03:12:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754552AbYAaILx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 03:11:53 -0500
Received: from pip23.gyao.ne.jp ([125.63.38.249]:60525 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754110AbYAaILw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 03:11:52 -0500
X-Greylist: delayed 1817 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Jan 2008 03:11:52 EST
Date: Thu, 31 Jan 2008 16:40:45 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Chris Snook <csnook@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Purpose of numa_node?
Message-ID: <20080131074045.GA13788@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org
References: <47A11ACD.1090400@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A11ACD.1090400@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 07:48:13PM -0500, Chris Snook wrote:
> While pondering ways to optimize I/O and swapping on large NUMA machines, I 
> noticed that the numa_node field in struct device isn't actually used 
> anywhere. We just have a couple dozen lines of code to conditionally 
>  create a sysfs file that will always return -1.  Is anyone even working on 
> code to actually use this field?  I think it's a good piece of information 
> to keep track of, so I'm not suggesting we remove it, but I want to make 
> sure I'm not stepping on toes or duplicating effort if I try to make it 
> useful.
> 
It's manipulated with accessors. If you look at the users of
dev_to_node()/set_dev_node() you can see where it's being used. It's
primarily used in allocation paths for node locality, and the existing
set_dev_node() callsites are places where node locality information
already exists (ie, which node a given controller sits on). You can see
this in places like PCI (pcibus_to_node()) and USB, with node allocation
hints used in places like the dmapool and skb alloc paths.

The in-kernel use looks perfectly sane in that regard, though I'm not
sure what the point of exporting this as a RO attribute to userspace is.
Presumably someone has a tool somewhere that cares about this.
