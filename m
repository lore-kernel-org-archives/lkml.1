Return-Path: <linux-kernel-owner+w=401wt.eu-S966137AbXDCBRD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966137AbXDCBRD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 21:17:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966138AbXDCBRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 21:17:03 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:5957 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966137AbXDCBRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 21:17:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=I/qlqtydeBg3Dd5kx99rGX/JaKdMPEskSVKlW1U+DLWeb8SrqaLJq8RyTb52JmJ66ZMfBIFi0RK9zmRakz4NIEAqF+LS7P2fH/JM0Tq/IS7yItBS7iZvqLAgeH0Gqt9U/Qxpfs13tq+GKjFTar4Gr1CNFaq9idsmSl1v8GXeb50=
Message-ID: <4611AAC1.8050303@gmail.com>
Date: Tue, 03 Apr 2007 09:15:45 +0800
From: Li Yu <raise.sail@gmail.com>
User-Agent: Thunderbird 1.5 (X11/20051201)
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       yanghong@ccoss.com.cn,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       hongzhiyi@ccoss.com.cn, LKML <linux-kernel@vger.kernel.org>,
       Li Yu <raise.sail@gmail.com>
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
References: <200703051532096508636@gmail.com> <45FE6971.6090503@gmail.com>	 <1174897676.5815.6.camel@violet> <4609CAF2.3040303@ccoss.com.cn>	 <Pine.LNX.4.64.0703280945560.19566@jikos.suse.cz>	 <d120d5000703281200wd914f51s18437a6a8e4107f6@mail.gmail.com>	 <1175516515.5815.347.camel@violet>	 <Pine.LNX.4.64.0704021429420.3808@jikos.suse.cz> <1175532439.5815.375.camel@violet>
In-Reply-To: <1175532439.5815.375.camel@violet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marcel Holtmann wrote:
> The cleanest solution without a layer violation is that you can
> register a driver for a specific VID/PID and then report id (one or
> more). All
> reports with ids that we don't have a special driver for are handled by
> the default HID->input driver or handed over to hidraw if not parseable.
> The reports for ids with a special driver are handed over to the driver.
>
> And for hidraw it would be nice if we can apply filters for specific
> report ids to keep the round-trips and overhead at a minimum.
>
>   
If we don't use "flip-flopping" means, the common driver and specific
driver concepts also don't need. They are completely same driver for HID
bus, just one without some hooks, another without. The common event
processing is an API from HID core. so, here have not round-trips.

What's the position of hidraw? It only is used when all other driver is
not usable on some report? or, it should be stick every working device.

PS: In last broken "flip-flopping" resolution, the USBHID work also need
some changes ;)

