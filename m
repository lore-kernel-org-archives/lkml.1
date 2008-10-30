Return-Path: <linux-kernel-owner+w=401wt.eu-S1756259AbYJ3PLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259AbYJ3PLP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 11:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755308AbYJ3PKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 11:10:45 -0400
Received: from bu3sch.de ([62.75.166.246]:58319 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755112AbYJ3PKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 11:10:44 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: ssb: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Thu, 30 Oct 2008 16:10:14 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
References: <1225378317.21973.1.camel@nga.site>
In-Reply-To: <1225378317.21973.1.camel@nga.site>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810301610.15087.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 October 2008 15:51:57 Kay Sievers wrote:
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
> Thanks,
> Kay
> 
> 
> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: ssb: struct device - replace bus_id with dev_name(), dev_set_name()
> 
> CC: Michael Buesch <mb@bu3sch.de>
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>

ACK

-- 
Greetings Michael.
