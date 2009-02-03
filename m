Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbZBCWYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbZBCWYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 17:24:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbZBCWYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 17:24:35 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:42499 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbZBCWYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 17:24:34 -0500
Message-ID: <4988C3E6.5010508@oracle.com>
Date: Tue, 03 Feb 2009 14:23:34 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH 1/2] atyfb: fix CONFIG_ namespace
 violations
References: <200901310909.n0V99XIZ021497@imap1.linux-foundation.org> <4984AC40.8030708@oracle.com> <20090131121008.eb7f5ddd.akpm@linux-foundation.org> <20090202150002.05838fed.randy.dunlap@oracle.com> <Pine.LNX.4.64.0902030907350.15898@anakin> <20090203110631.GB22401@sci.fi>
In-Reply-To: <20090203110631.GB22401@sci.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4988C3E4.010D:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ville Syrjälä wrote:
> On Tue, Feb 03, 2009 at 09:09:38AM +0100, Geert Uytterhoeven wrote:
>> On Mon, 2 Feb 2009, Randy Dunlap wrote:
>>> --- linux-2.6.29-rc3-git3.orig/drivers/video/aty/atyfb_base.c
>>> +++ linux-2.6.29-rc3-git3/drivers/video/aty/atyfb_base.c
>>> @@ -135,7 +135,7 @@
>>>  #if defined(CONFIG_PM) || defined(CONFIG_PMAC_BACKLIGHT) || \
>>>  defined (CONFIG_FB_ATY_GENERIC_LCD) || defined(CONFIG_FB_ATY_BACKLIGHT)
>>>  static const u32 lt_lcd_regs[] = {
>>> -	CONFIG_PANEL_LG,
>>> +	CNFG_PANEL_LG,
>> These were the official names as used in the ATI docs. After these changes, you
>> can no longer easily grep for them.
>>
>> Perhaps it's better to prefix everything with ATI_? yes, I know it's more work
>> (for the writer), but we want to optimize for the reader, right?

Everything??  not just the CONFIG_* namespace violations?

[If so,] Potentially 3600 changes just in 3 header files, then all of
the corresponding .c files.  No thanks.

How about a note in the header files that explains that CONFIG_* register
names are spelled as "CNFG_*" so that there are not kernel kconfig
namespace conflicts?


> That would be my preference as well.

Care to do it?

-- 
~Randy
