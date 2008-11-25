Return-Path: <linux-kernel-owner+w=401wt.eu-S1753372AbYKYSWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbYKYSWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 13:22:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbYKYSWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 13:22:36 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51983 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbYKYSWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 13:22:35 -0500
Date: Tue, 25 Nov 2008 13:22:31 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Matthew Wilcox <matthew@wil.cx>,
       Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: parisc: struct device - replace bus_id with dev_name(),
	dev_set_name()
Message-ID: <20081125182231.GG30056@bombadil.infradead.org>
References: <1226018566.3189.13.camel@nga>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226018566.3189.13.camel@nga>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 01:42:46AM +0100, Kay Sievers wrote:
> (I did not compile or test it, please let me know, or help fixing
>  it, if something is wrong with the conversion)
> 
> This patch is part of a larger patch series which will remove
> the "char bus_id[20]" name string from struct device. The device
> name is managed in the kobject anyway, and without any size
> limitation, and just needlessly copied into "struct device".
> 
> To set and read the device name dev_name(dev) and dev_set_name(dev)
> must be used. If your code uses static kobjects, which it shouldn't
> do, "const char *init_name" can be used to statically provide the
> name the registered device should have. At registration time, the
> init_name field is cleared, to enforce the use of dev_name(dev) to
> access the device name at a later time.
> 
> We need to get rid of all occurrences of bus_id in the entire tree
> to be able to enable the new interface. Please apply this patch,
> and possibly convert any remaining remaining occurrences of bus_id.
> 
> We want to submit a patch to -next, which will remove bus_id from
> "struct device", to find the remaining pieces to convert, and finally
> switch over to the new api, which will remove the 20 bytes array
> and does no longer have a size limitation.
> 

Applied, thanks Kay.
