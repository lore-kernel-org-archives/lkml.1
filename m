Return-Path: <linux-kernel-owner+w=401wt.eu-S1753920AbYGVP26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbYGVP26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 11:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbYGVP2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 11:28:50 -0400
Received: from smtp1.extricom.com ([212.235.24.249]:49975 "HELO
	smtp.extricom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1750869AbYGVP2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 11:28:50 -0400
Message-ID: <4885FBF4.6070306@extricom.com>
Date: Tue, 22 Jul 2008 18:25:40 +0300
From: Eran Liberty <liberty@extricom.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: eran liberty <eran.liberty@gmail.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 2.6.26] PCI: refuse to re-add a device to a bus upon pci_scan_child_bus()
References: <48591941.4070408@extricom.com> <4884E0FB.9010909@extricom.com> <20080721194957.GH24246@parisc-linux.org> <ffc2b1d40807220121r44823a89jf0126bc1f5273443@mail.gmail.com> <20080722114929.GA7337@parisc-linux.org> <4885DD41.9010202@extricom.com> <20080722141327.GB7337@parisc-linux.org>
In-Reply-To: <20080722141327.GB7337@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> If this is all alone on a bus of its own, we can certainly handle that.
> Maybe we can make it a module parameter or something.
>   
If my devices where the only one on the bus I would not have stumbled on 
this bug. I would have removed them all before reloading and would have 
scanned and empty PCI bus list after the reloading.

Alas, the CPU itself is a pci device. Upon scanning the bus it is it who 
is duplicated. Upon trying to "pci_bus_add_devices()" you get resource 
collision.

Do you perceive any down side to my suggested patch?
It seems (to me) really logical that a device can not and should not be 
added twice to a pci bus device list.

Liberty
