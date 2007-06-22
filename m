Return-Path: <linux-kernel-owner+w=401wt.eu-S1754230AbXFVTrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbXFVTrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 15:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbXFVTrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 15:47:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:33253 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbXFVTro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 15:47:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PBSJj3ItlVYFUQpm7SnrnOV6uSvzMyLKvBCRHNQ4TQwZqPC9r6v4svM5V31YqReFw0/29oJu1NTJJX/31Sjnxs6FoeTkr36PsAFXkTwxWpK9eixJ21tM/7vckLdQ7Nk5xXztjdkm2lAXD3YBOJ6LK5iemqDkKODsSzQjj8Xaze8=
Message-ID: <d120d5000706221247g618fffadh2c4296aa62a39b9e@mail.gmail.com>
Date: Fri, 22 Jun 2007 15:47:43 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: Writing a driver for a legacy serial device
Cc: LKML <linux-kernel@vger.kernel.org>, "Vojtech Pavlik" <vojtech@ucw.cz>
In-Reply-To: <20070621113358.1d65678d@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070619190502.05d4e0c8@hyperion.delvare>
	 <d120d5000706191159w29ebd0dajbd6cb9ac78d4faa2@mail.gmail.com>
	 <20070620105648.6d18ad66@hyperion.delvare>
	 <200706202311.33326.dtor@insightbb.com>
	 <20070621113358.1d65678d@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/21/07, Jean Delvare <khali@linux-fr.org> wrote:
>
> OK. This leads me to a question: is it OK for me to add support for my
> non-input device to inputattach, or is a separate, dedicated helper
> tool preferred? Both ways are fine with me, I don't know what the input
> subsystem maintainers expect.
>

Your device does not need any initialization done by userspace, does
it? How widespread is this device? inputattach has "--dump" option
which sets up a SERIO_RS232/0/0/0 serio port. You could mark your
serio driver as manual bind driver and bind it trhough sysfs (echo -n
"taos-evm" /sys/device/serio/devices/serioX/drvctl to bind it).

-- 
Dmitry
