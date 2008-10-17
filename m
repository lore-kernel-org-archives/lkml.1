Return-Path: <linux-kernel-owner+w=401wt.eu-S1755546AbYJQOqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbYJQOqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 10:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754443AbYJQOqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 10:46:44 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:11557 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbYJQOqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 10:46:43 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: n0ano@n0ano.com
Subject: Re: [PATCH] Enable console on PCI serial devices
Date: Fri, 17 Oct 2008 08:46:40 -0600
User-Agent: KMail/1.9.9
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, donald.d.dugger@intel.com,
       linux-kernel@vger.kernel.org
References: <200810142231.m9EMV95O002974@los-vmm.sc.intel.com> <20081017102858.1f1d77f7@lxorguk.ukuu.org.uk> <20081017141102.GG14490@xolotl.n0ano.com>
In-Reply-To: <20081017141102.GG14490@xolotl.n0ano.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810170846.41032.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 October 2008 08:11:02 am n0ano@n0ano.com wrote:
> On Fri, Oct 17, 2008 at 10:28:58AM +0100, Alan Cox wrote:
> > Different discussion and different patches. We can get patches in for the
> > crystal frequency stuff and then debate the rest later
> 
> In that case, here is the crystal frequency patch (typos fixed and
> proper sign off line).

I like this patch, except ...

> +			"options" are the same as for ttyS, above.  "clk"
> +			is the crystal frequency which defaults to 115200
> +			(typically the fastest baud rate supported by the
> +			uart) but some hardware use different crystals.

this text is a little confusing.  Since you multiply by 16 below, the
number specified by the user isn't really the crystal frequency, is it?

> +	options = strchr(options, ',');
> +	if (options) {
> +		options++;
> +		port->uartclk = simple_strtoul(options, NULL, 0) * 16;
> +	}
