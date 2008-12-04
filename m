Return-Path: <linux-kernel-owner+w=401wt.eu-S1756617AbYLDJM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617AbYLDJM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 04:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbYLDJMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 04:12:38 -0500
Received: from smtp1.stealer.net ([88.198.224.204]:43093 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbYLDJMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 04:12:35 -0500
Date: Thu, 4 Dec 2008 10:12:16 +0100 (CET)
From: Sven Wegener <sven.wegener@stealer.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Matt_Domsch@dell.com, greg@kroah.com,
       linux-acpi@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
       Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 2/2 update] misc: Add dell-laptop driver
In-Reply-To: <20081203195238.GA22560@srcf.ucam.org>
Message-ID: <alpine.LNX.2.00.0812040934080.16637@titan.stealer.net>
References: <20081127163357.GA22846@srcf.ucam.org> <20081127163444.GB22846@srcf.ucam.org> <20081202115029.2b9d1153.akpm@linux-foundation.org> <20081202201645.GB31620@srcf.ucam.org> <alpine.LFD.2.00.0812031414150.3255@localhost.localdomain>
 <20081203195238.GA22560@srcf.ucam.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -0.1
X-Spam-Bar: /
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Thu, 04 Dec 2008 09:12:29 +0000
	Bayes: 0.3075 Tokens: new, 252; hammy, 7; neutral, 4; spammy, 1.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.3075]
X-Spam-Signature: ff715f48714e57ac3e698146dbd1947961722d3a
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2008, Matthew Garrett wrote:

> Add a driver for controling Dell-specific backlight and rfkill 
> interfaces. This driver makes use of the dcdbas interface to the Dell 
> firmware to allow the backlight and rfkill interfaces on Dell systems to 
> be driven through the standardised sysfs interfaces.

> +static void parse_da_table(const struct dmi_header *dm)

__init

> +static void find_tokens(const struct dmi_header *dm)

__init

> +{
> +	switch (dm->type) {
> +	case 0xd4: /* Indexed IO */
> +		break;
> +	case 0xd5: /* Protected Area Type 1 */
> +		break;
> +	case 0xd6: /* Protected Area Type 2 */
> +		break;
> +	case 0xda: /* Calling interface */
> +		parse_da_table(dm);
> +		break;
> +	}

This could be a simple if (dm->type == 0xda), it looks like the switch
is abused as documentation.

> +/* Derived from information in DellWirelessCtl.cpp:
> +   Class 17, select 11 is radio control. It returns an array of 32-bit values.
> +
> +   result[0]: return code
> +   result[1]:
> +     Bit 0:      Hardware switch supported
> +     Bit 1:      Wifi locator supported
> +     Bit 2:      Wifi is supported
> +     Bit 3:      Bluetooth is supported
> +     Bit 4:      WWAN is supported
> +     Bit 5:      Wireless keyboard supported
> +     Bits 6-7:   Reserved
> +     Bit 8:      Wifi is installed
> +     Bit 9:      Bluetooth is installed
> +     Bit 10:     WWAN is installed
> +     Bits 11-15: Reserved
> +     Bit 16:     Hardware switch is on
> +     Bit 17:     Wifi is blocked
> +     Bit 18:     Bluetooth is blocked
> +     Bit 19:     WWAN is blocked
> +     Bits 20-31: Reserved
> +   result[2]: NVRAM size in bytes
> +   result[3]: NVRAM format version number

Could these bit numbers be defines with declarative names, e.g define
DELL_WIFI_BLOCKED (1<<17)? It would make reading the code that just uses
plain numbers easier.

> +	memset(&buffer, 0, sizeof(struct calling_interface_buffer));

sizeof(buffer)

Likewise for other sizeof() occurrences that follow.

> +static int dell_setup_rfkill(void)

__init

Sven
