Return-Path: <linux-kernel-owner+w=401wt.eu-S932480AbXBJO41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480AbXBJO41 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 09:56:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932581AbXBJO41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 09:56:27 -0500
Received: from wx-out-0506.google.com ([66.249.82.228]:1912 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932480AbXBJO40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 09:56:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=pmcDOnc0Vz8O0TdRFKIFR9KbVXCidlVe6WkwieCFmVv3gxCZ3KGnGcnmwwfi8Ti+NSYsK1U/9vafUUMWiCFR/wKKsJLrRWWoF7BINOkfWAVR8hTcFVBmC2sokOT2gd9CEcIO0uQRVPTu74Lrr6EAXLMMy2pQVMmWhPo9XPt8TFo=
Message-ID: <45CDDCF9.4080909@gmail.com>
Date: Sat, 10 Feb 2007 09:55:53 -0500
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Keenan Pepper <keenanpepper@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: More ICH7 PATA freezes with ata_piix
References: <767314830702091348q523ba574u62efc3c0b93a4381@mail.gmail.com>
In-Reply-To: <767314830702091348q523ba574u62efc3c0b93a4381@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Keenan Pepper wrote:
[--snip--]
> [ 1169.712000] ata1.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> [ 1169.712000] ata1.01: cmd a0/00:00:00:00:20/00:00:00:00:00/b0 tag 0 cdb 0x1e data 0 
> [ 1169.712000]          res 40/00:03:00:00:00/00:00:00:00:00/b0 Emask 0x4 (timeout)
> [ 1176.712000] ata1: port is slow to respond, please be patient (Status 0xd0)
> [ 1199.728000] ata1: port failed to respond (30 secs, Status 0xd0)

Hmm.. ALLOW_MEDIUM_REMOVAL failed with timeout.  To me it seems that 
your TSST dvdw doesn't like being poked continuously.  I'm not sure how 
HAL is currently poling but it seems each poll involves opening and 
closing thus invoking whole media revalidation and medium removal 
disallow/allow switching.  You're not the first one reporting similar 
problem.  Can you report it to HAL people?  I'd love to talk with them.

Thanks.

-- 
tejun
