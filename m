Return-Path: <linux-kernel-owner+w=401wt.eu-S1751611Ab0AKCPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611Ab0AKCPz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 21:15:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280Ab0AKCPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 21:15:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:43674 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259Ab0AKCPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 21:15:53 -0500
Message-ID: <4B4A8A54.8030406@kernel.org>
Date: Mon, 11 Jan 2010 11:17:56 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: Torsten Kaiser <just.for.lkml@googlemail.com>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       linux-ide@vger.kernel.org
Subject: Re: MSI broken in libata?
References: <64bb37e0912250122n4e0e1842q88c0dad7e99ec6a7@mail.gmail.com>	 <4B484829.6060405@kernel.org> <64bb37e1001092033r1f0b4defw46c1a07101bb2d1b@mail.gmail.com> <4B4A7BC7.6060106@kernel.org> <4B4A815A.60503@gmail.com>
In-Reply-To: <4B4A815A.60503@gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 11 Jan 2010 02:15:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Robert.

On 01/11/2010 10:39 AM, Robert Hancock wrote:
> It'd be interesting to see if it makes a difference, but I don't think
> the patch is quite right. According to the datasheet, doing the MSI ack
> while the interrupt source is still pending will cause a new MSI to be
> sent, so if you do it before handling the interrupt you'll generate a
> spurious interrupt after every real one.

Ah... okay, so the generation of MSI is level triggered?  If so, your
original patch is correct.  I was thinking it might be edge triggered
and it should be cleared before checking master event mask.

Thanks.

-- 
tejun
