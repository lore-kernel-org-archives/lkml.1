Return-Path: <linux-kernel-owner+w=401wt.eu-S1751518AbXJULiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbXJULiW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 07:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbXJULiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 07:38:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:1800 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbXJULiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 07:38:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=cwOsJz/wrQ/xR9c5umVOZMh8Wmg4x6uhFDJhDX9QJqlyGRNJKrRcD8UdTagU1WW/vdQ9gXZ/VtEmtUsYKUBjjr0Q7BPb5kihgGXPKU2ug5ifGDSOtXzAraXQprVklDLrrvH9l/iT0yn7WJilNgYUrnIGXFhDcWUVxjtZq9QbpEs=
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [Rt2400-devel] rt73usb: support for wireless in Kohjinsha subnotebook
Date: Sun, 21 Oct 2007 15:56:29 +0200
User-Agent: KMail/1.9.7
Cc: rt2400-devel@lists.sourceforge.net,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org, mwallis@serialmonkey.com
References: <20071020184100.GA11640@elf.ucw.cz> <200710210012.37547.IvDoorn@gmail.com> <20071021092048.GA25270@elf.ucw.cz>
In-Reply-To: <20071021092048.GA25270@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710211556.29469.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > If rt2x00 is loaded and detected the device, it should print out a debug message that starts with:
> > "Chipset detected - " What is in your case the complete line?
> 
> Ok, I guess I should include more complete debug output.
> 
> phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x09 failed for offset 0x0000 with error -32

- Vendor requests error with the -32 errors often indicate the incorrect device.

> phy0 -> rt73usb_validate_eeprom: EEPROM recover - MAC: 66:76:2b:e8:68:e7

- Incorrect MAC address read from the device. Another hint that the device is not rt73.

> phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x3000 with error -32
> phy0 -> rt2x00_set_chip: Info - Chipset detected - rt: 1300, rf: 0000, rev: c03c0ae0

- A incorrect RF chipset. (valid values are: 1, 2, 3 or 4). Another indication of a incorrect device.
- A completely bogus chipset revision. A valid rt73 device has the revision "2573X" Where only the
  X is a variable.

> phy0 -> rt73usb_init_eeprom: Error - Invalid RF chipset detected
> 
> ...so, I think hardware is indeed quite similar to what rt73usb driver
> expects...?

No. You can assume you are forcing rt73 to control a non-rt73 device.
The fact that you had to hack to bypass the RT and RF chipset validation also confirms that,
those checks were there for a reason. Namely to make sure the corect driver was being used for the device.

Ivo
