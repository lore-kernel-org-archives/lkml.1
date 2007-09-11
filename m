Return-Path: <linux-kernel-owner+w=401wt.eu-S1759784AbXIKP2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759784AbXIKP2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 11:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755083AbXIKP2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 11:28:06 -0400
Received: from mga10.intel.com ([192.55.52.92]:31542 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755071AbXIKP2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 11:28:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,238,1186383600"; 
   d="scan'208";a="132861110"
Date: Tue, 11 Sep 2007 08:32:09 -0700
From: "Lombard, David N" <dnlombar@ichips.intel.com>
To: Bernhard Walle <bwalle@suse.de>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [patch 1/5] Extended crashkernel command line
Message-ID: <20070911153209.GA5054@nlxdcldnl2.cl.intel.com>
Mail-Followup-To: Bernhard Walle <bwalle@suse.de>,
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org
References: <20070909083914.065380136@strauss.suse.de> <20070909083914.488571169@strauss.suse.de> <20070911131445.GA17460@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070911131445.GA17460@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2007 at 03:14:45PM +0200, Olaf Dabrunz wrote:
> On 09-Sep-07, Bernhard Walle wrote:
> > If there are multiple occurrences, then the last one is taken.  The advantage
> > is that if you have a bootloader like lilo or elilo which allows you to append
> > a command line parameter but not to remove one (like in GRUB), then you can add
> > another crashkernel value for testing at the boot command line and this one
> > overwrites the command line in the configuration then.
> 
> AFAIK it is the other way round: the lilo configuration-parameter
> "append" appends the kernel parameters in the configuration to the
> parameters given by the user on the kernel command line.
> 
> So the parameters set by the user during boot appear first on the
> command line.

Given the kernel itself processes the cmdline from front to back,
that suggests the last value is the correct value.


A survey of bootloaders shows differing behaviors:

syslinux et al.:
  APPEND options...
    Add one or more options to the kernel command line.  These are
    added both for automatic and manual boots.  The options are
    added at the very beginning of the kernel command line,
    usually permitting explicitly entered kernel options to override
    them.  This is the equivalent of the LILO "append" option.

lilo:
  append=<string>

    Appends the options specified to the parameter line passed to
    the kernel.  This is typically used to specify hardware parameters
    that can't be entirely auto-detected or for which probing may be
    dangerous. Multiple kernel parameters are separated by a blank
    space, and the string must be enclosed in double quotes.  A local
    append= appearing withing an image= section overrides any
    global append= appearing in the top section of the configuration file.
    Append= may be used only once per "image=" section.

    [There's also a local addappend string that's appended to the append string]

elilo:
  append=string       Append a string of options to kernel command line
    ...
    The user can specify a kernel and related kernel options using the image
    label. Alternatively, the user can also specify a kernel file that is
    not specified in the config file. In any case, some of the global options
    (such as append) are always concatenated to whatever the user type.

Grub:
  Interactive editing of the command line...

kboot
  Config file entries precede user's values from keyboard



-- 
David N. Lombard, Intel, Irvine, CA
I do not speak for Intel Corporation; all comments are strictly my own.
