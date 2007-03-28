Return-Path: <linux-kernel-owner+w=401wt.eu-S965657AbXC1TAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965657AbXC1TAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 15:00:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965689AbXC1TAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 15:00:11 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:64123 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965687AbXC1TAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 15:00:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hD5SX9zOsV4uUh+267qLQFmzvqJKC1N8vTnv+4QlRVhJJXQ81kjh85Y6Pn9gmWEYFQGvvP5jcT5q954Sp0HBWcWXGmX7jEQBcRphpSTbC/0McZ585k2IdLU7rIkSvvQcbDA2aP/lq/lu5bhRWg3VtoPgBtYwoUIXdCcZlPSn1To=
Message-ID: <d120d5000703281200wd914f51s18437a6a8e4107f6@mail.gmail.com>
Date: Wed, 28 Mar 2007 15:00:06 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
Cc: "Li Yu" <liyu@ccoss.com.cn>, yanghong@ccoss.com.cn,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       hongzhiyi@ccoss.com.cn, "Marcel Holtmann" <marcel@holtmann.org>,
       LKML <linux-kernel@vger.kernel.org>, "Li Yu" <raise.sail@gmail.com>
In-Reply-To: <Pine.LNX.4.64.0703280945560.19566@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703051532096508636@gmail.com> <45FE6971.6090503@gmail.com>
	 <1174897676.5815.6.camel@violet> <4609CAF2.3040303@ccoss.com.cn>
	 <Pine.LNX.4.64.0703280945560.19566@jikos.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/28/07, Jiri Kosina <jkosina@suse.cz> wrote:
>
> The crucial thing here is that all reports but the ones that the driver
> registered to will be processed in a standard way by the generic hid bus
> layer, and those reports that the driver registered to will be ignored by
> the layer, and passed for processing to the driver.
>

I don't think it is a good idea to register driver for specific
usages/reports. Quite often you want to adjust processing of a report
for a specific device. What if there are 2 devices that need such
quirks? How will you do hotplug and module loading? Emit new uevent
for every report? Also, what about users and Kconfig? "Driver for
usage 0x000012345. Say Y if your hardware does not wotk correctly with
defautl handler for this usage and require special processing"???

Just register based on VID/PID and provide standard
hid_default_input_event() to drivers so they would call it for reports
they don't need to do special processing on.

-- 
Dmitry
