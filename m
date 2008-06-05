Return-Path: <linux-kernel-owner+w=401wt.eu-S1757287AbYFEUMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287AbYFEUMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 16:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbYFEUMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 16:12:14 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:57215 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733AbYFEUMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 16:12:13 -0400
Message-ID: <4848489C.6010903@garzik.org>
Date: Thu, 05 Jun 2008 16:12:12 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/18] firmware: moving drivers to request_firmware()
References: <20080605.foo@pmac.infradead.org>  <48483BA9.1070200@garzik.org> <1212695675.32207.288.camel@pmac.infradead.org>
In-Reply-To: <1212695675.32207.288.camel@pmac.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> On Thu, 2008-06-05 at 15:16 -0400, Jeff Garzik wrote:
>> Why do we need the .ihex format?
>>
>> We should be loading firmwares exactly as they come from the vendor, 
>> without any wrappers.
> 
> It's just 'objcopy -Ibinary -Oihex foo foo.ihex'. It's purely for
> convenience of handling the binary blobs in git (and it means we can
> append licensing information after the EOF record too, if we want).

Well, I should ask, is this purely an internal build detail?

The developer (and user) should never ever see a .ihex file, outside of 
an active kernel compile.  Wrapping the original firmware makes it more 
difficult to verify, compare and/or change.  In-tree, we should see the 
vendor firmware blobs as shipped, with no wrapping or modification or 
anything.

Any metadata can be added as a separate file.

If .ihex is purely a temporary thing during compile, no big deal, ignore 
me.  Otherwise, that's something we should avoid.

	Jeff




