Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbYGWBcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbYGWBcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 21:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbYGWBcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 21:32:25 -0400
Received: from outbound-mail-126.bluehost.com ([67.222.38.26]:39997 "HELO
	outbound-mail-126.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750857AbYGWBcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 21:32:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=Pe76SRt4WwpfuNE1BaVz66PNBGWXKlxdo/X0OxhlVAbVCH/W4kmlkXl0hw5dadMXurBYOyaIoT0GNDRXs5ietpJY1kqePBv6pbloAijLkqQBftQVW9xNNwvRzc7vQpMe;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jack Howarth <howarth@bromo.msbb.uc.edu>
Subject: Re: [PATCH] x86,pci: dmi check for mackpro 2.2 mmconf
Date: Tue, 22 Jul 2008 18:32:20 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Shaohua Li <shaohua.li@intel.com>
References: <20080722233722.GA12247@bromo.msbb.uc.edu> <200807221723.04654.jbarnes@virtuousgeek.org> <20080723010058.GA12662@bromo.msbb.uc.edu>
In-Reply-To: <20080723010058.GA12662@bromo.msbb.uc.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807221832.21167.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 22, 2008 6:00 pm Jack Howarth wrote:
> Jesse,
>     I found that patch right after I sent the email. Applying the ASPM
> patch solves the boot hangs on under 2.6.26-git9 built with
> CONFIG_PCIEASPM=y. I am attaching the dmesg log for such a boot
> below. I am a little confused if the patch totally disables aspm on
> my machine or just inhibits the hang. Is there a proc entry I can check
> to monitor that aspm is in use?

It should disable ASPM on pre-1.1 PCIe devices, since apparently many of them 
get ASPM wrong, resulting in bus hangs.  There's a file in sysfs to control 
things:
/sys/module/pcie_aspm/parameters/policy
(see the description in 7d715a6c1ae5785d00fb9a876b5abdfc43abc44b for info).

With the patch applied hopefully it indicates that things are disabled.

Thanks for testing.

Jesse
