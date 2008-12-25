Return-Path: <linux-kernel-owner+w=401wt.eu-S1752318AbYLYIUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbYLYIUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 03:20:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751007AbYLYIUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 03:20:40 -0500
Received: from colo.lackof.org ([198.49.126.79]:40457 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279AbYLYIUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 03:20:40 -0500
Date: Thu, 25 Dec 2008 01:20:27 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Micha? Miros?aw <mirq-linux@rere.qmqm.pl>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: RFC: pci_write_bits*() convenience functions
Message-ID: <20081225082027.GB11032@colo.lackof.org>
References: <20081223215938.GA32714@rere.qmqm.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081223215938.GA32714@rere.qmqm.pl>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2008 at 10:59:38PM +0100, Micha? Miros?aw wrote:
...
> What's interesting, there are 2039 lines where pci_read_config_*() is used
> and in only about 161 the return value is checked (as of current linux-2.6.git
> tree: commit 3d44cc3e01..., quick grep test).

A very few of those config reads are for flushing MMIO commands to devices.
ISTR we had a case where resetting the device would cause MMIO reads to
Master Abort (timeout). It's ok for config cycles to Master Abort.
It's generally NOT OK for MMIO cycles to Master Abort.

However, your point is correct. Most of the time, we (driver writers) assume
the config cycle will either succeed or return ~0 (to indicate Master Abort).
And in some very few and extremely old PCI machines, return 0.

hth,
grant
