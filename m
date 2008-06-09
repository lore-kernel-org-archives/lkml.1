Return-Path: <linux-kernel-owner+w=401wt.eu-S1754798AbYFIEDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbYFIEDG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 00:03:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750699AbYFIECy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 00:02:54 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:13680 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbYFIECx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 00:02:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Hm2hw35aigMT9CSdiHLT85ZGfqTvJXZszWOo60g3omtyFEEFPOqFQM8eAQXw4eTVrb
         kuUOrWY91t/dWklY2zRL+jYa3X2P+18WR6dZiiJ6tABUXfGAGD3SY6u3ZLaIVgnLNLJ7
         DfA/lnecsw/D55sYShPWf/Z38dzoP3kG5Ctuo=
Message-ID: <dd18b0c30806082102h5d3e3928j98d01b71dba729f9@mail.gmail.com>
Date: Mon, 9 Jun 2008 04:02:51 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Matthew Garrett" <mjg59@srcf.ucam.org>
Subject: Re: BUG: unable to handle kernel paging request at f8dbf000 "isight_firmware"
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <dd18b0c30806081723y77f5038fm427b020d3723706a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30806081151q7895a930te5fd374e35471c7a@mail.gmail.com>
	 <20080608231105.GA28358@srcf.ucam.org>
	 <dd18b0c30806081723y77f5038fm427b020d3723706a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 9, 2008 at 12:23 AM, Justin Mattock <justinmattock@gmail.com> wrote:
> On Sun, Jun 8, 2008 at 11:11 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>> On Sun, Jun 08, 2008 at 06:51:42PM +0000, Justin Mattock wrote:
>>
>>> Now on to the status with isight firmware, It seems The two modules
>>> are loading uvcvideo and isight_firmware, but there not talking with
>>> each other upon booting,
>>
>> I'm not quite sure I understand. They don't talk to each other as such -
>> the firmware driver loads the firmware, at which point the isight will
>> disconnect and reappear with a new USB id. uvcvideo should then be able
>> to bind. What are you actually seeing?
>>
>> --
>> Matthew Garrett | mjg59@srcf.ucam.org
>>
>
> There not binding, or uvcvideo is not binding,
> under dmesg I see:
> when not binding:
> [   14.971002] firmware: requesting isight.fw
> [   15.183152] usbcore: registered new interface driver isight_firmware
>
> [   16.849152] usbcore: registered new interface driver uvcvideo
>
> when binded:
>
> [   15.319330] firmware: requesting isight.fw
> [   15.433080] usbcore: registered new interface driver isight_firmware
>
> [   16.810149] usbcore: registered new interface driver uvcvideo
> [   17.810745] uvcvideo: Found UVC 1.00 device Built-in iSight (05ac:8501)
> [   17.819252] uvcvideo: Failed to query (135) UVC control 1 (unit 0)
> : -32 (exp. 26).
>
> I've noticed the not binding more than binding. Usually I have to
> start the system and remove the two modules, and then modprobe the two
>  then a reboot to have a proper load or binding of the two. Keep in
> mind I am using a uvcvideo module that is a few weeks old, so maybe
> this
> is whats causing this.
> regards;
> --
> Justin P. Mattock
>

O.K. after loading the latest uvcvideo, the issue is still prevalent.,
Hopefully I explain to you so you can get an
idea of what I'm seeing: on a cold boot the isight_firmware and
uvcvideo are not binding, but If after the system starts from the cold
boot, with
isight_firmware and uvcvideo not binding, a simlple rmmod and modprobe
of the two modules will bind the two. then with a reboot
the two will almost certainly stay binded, but if instead of a reboot
a shutdown -h now. upon starting up the two won't be binded anymore.
almost as if the firmware is loading in the wrong location, but am
uncertain how that area works.
Hope this helps you, better see the problem I'm looking at.
regards;

-- 
Justin P. Mattock
