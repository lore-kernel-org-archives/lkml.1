Return-Path: <linux-kernel-owner+w=401wt.eu-S1754471AbYJTRoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbYJTRoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 13:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbYJTRoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 13:44:12 -0400
Received: from willie.n0ano.com ([64.66.241.76]:55715 "EHLO xolotl.n0ano.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752287AbYJTRoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 13:44:10 -0400
From: n0ano@n0ano.com
Date: Mon, 20 Oct 2008 11:43:51 -0600
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>, n0ano@n0ano.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, donald.d.dugger@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Enable console on PCI serial devices
Message-ID: <20081020174351.GK14490@xolotl.n0ano.com>
References: <200810142231.m9EMV95O002974@los-vmm.sc.intel.com> <20081017170638.GJ14490@xolotl.n0ano.com> <20081020164404.GE22851@csclub.uwaterloo.ca> <200810201111.08703.bjorn.helgaas@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810201111.08703.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 11:11:07AM -0600, Bjorn Helgaas wrote:
>... 
> It doesn't bother me that the number is large.  It's only a factor
> of 16 bigger than the baud rate.  It is sort of magic, but on the
> other hand, the number is often printed on a part on the board, so
> it's easy to determine, and fairly easy to document.  If you've
> lost the box with the marketing messages on it, I'd argue that it's
> easier to determine the clock rate than the fastest baud rate.
> 
> To me it seems more confusing to specify two baud rates: the one
> you want to use, and the fastest one the UART supports.

Well, how about consistency with the current serial driver.  The
current driver uses base baud, as evidenced by this code from
`drivers/serial/8250_pci.c':

static struct pciserial_board pci_boards[] __devinitdata = {
        [pbn_default] = {
                .flags          = FL_BASE0,
                .num_ports      = 1,
                .base_baud      = 115200,
                .uart_offset    = 8,
        },

I think it's even more important to follow what the driver is
doing.  (If I'd lost the bix I would get the PCI IDs and see
what the driver is doing for my unknown card :-)

-- 
Don Dugger
"Censeo Toto nos in Kansa esse decisse." - D. Gale
n0ano@n0ano.com
Ph: 303/443-3786
